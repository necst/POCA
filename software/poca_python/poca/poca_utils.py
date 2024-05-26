import copy
import os
from pynq.mmio import MMIO

from .pynq_utils import ControlRegister, ArgumentRegister

# IMPORTANT: change this file to match the generated Vivado hardware specification
POCA_IP_BASE = 0xA0000000
POCA_IP_RANGE = 0x10000
POCA_IP_CTRL_OFFSET = 0x0
POCA_IP_LEN_OFFSET = 0x10
POCA_IP_KEY_OFFSET = 0x18
POCA_IP_IV_OFFSET = 0x3C
POCA_IP_PT_OFFSET = 0x50
POCA_IP_CT_OFFSET = 0x5C
POCA_IP_MODE_OFFSET = 0x68
POCA_IP_SIZE_OFFSET = 0x70
POCA_IP_DIR_OFFSET = 0x78

POCA_MAX_FREQ = [300, 300, 300, 300, 300, 300]

BITSTREAMS_DIR = os.path.dirname(__file__) + '/bitstreams'
# BITSTREAMS_DIR = '/home/xilinx/poca_python_lib/poca/bitstreams'

class CipherConfiguration:

    def __init__(self, mode, key, iv=None, nonce=None):
        if mode not in [0, 1, 2]:
            raise ValueError('Invalid mode specified')
        elif len(key) not in [16, 24, 32]:
            raise ValueError('Invalid key size. Make sure to use a 128, 192 or 256 bit key')
        elif iv is not None and len(iv) != 16:
            raise ValueError('Invalid IV size. Make sure to use a 128 bit IV')
        elif nonce is not None and len(nonce) != 12:
            raise ValueError('Invalid nonce size. Make sure to use a 96 bit nonce')

        if mode == 1 and iv is None:
            raise ValueError('IV must be specified for CBC mode')
        elif mode == 2 and nonce is None:
            raise ValueError('Nonce must be specified for CTR mode')
        
        self.mode = mode
        self.key = int.from_bytes(key, 'big')
        self.key_arr = []

        for i in range(0, 32, 4):
            self.key_arr.append((self.key >> (i * 8)) & 0xFFFFFFFF)

        self.iv = int.from_bytes(iv, 'little') if iv is not None else None
        self.iv_bytes = iv.ljust(16, b'\x00') if iv is not None else b'\x00' * 16
        self.nonce = int.from_bytes(nonce.ljust(16, b'\x00'), 'big') if nonce is not None else None
        self.nonce_bytes = nonce.ljust(16, b'\x00') if nonce is not None else b'\x00' * 16
        self.key_size = [16, 24, 32].index(len(key))
        self.max_length = 2 ** 32 - 1

        if self.mode == 0:
            self.params = [0, 0, 0, 0]
        elif self.mode == 1:
            self.params = []
            for i in range(0, 16, 4):
                self.params.append((self.iv >> (i * 8)) & 0xFFFFFFFF)
        else:
            self.params = []
            for i in range(0, 16, 4):
                self.params.append((self.nonce >> (i * 8)) & 0xFFFFFFFF)

    def apply(self, length, pt_ptr, ct_ptr, dir, nonce_add=0):
        t = copy.deepcopy(self)

        t.length = length
        t.pt_ptr = pt_ptr
        t.ct_ptr = ct_ptr
        t.dir = dir
        if t.nonce is not None:
            t.nonce += nonce_add

        return t

    def build_config(self, length, pt_ptr, ct_ptr, dir, nonce_add=0):
        config = [
            0, 0, 0, 0, length, 0, *self.key_arr, 0, self.params[0] + nonce_add, self.params[1], self.params[2], self.params[3], 0, pt_ptr, 0, 0, ct_ptr, 0, 0, self.mode, 0, self.key_size, 0, self.dir, 0
        ]

        return config


class POCAInterface:

    def __init__(self, index):
        self.mmio = MMIO(POCA_IP_BASE + index * POCA_IP_RANGE, POCA_IP_RANGE)
        self.CTRL = ControlRegister(self.mmio, POCA_IP_CTRL_OFFSET)
        self.length = ArgumentRegister(self.mmio, POCA_IP_LEN_OFFSET, 4)
        self.key = ArgumentRegister(self.mmio, POCA_IP_KEY_OFFSET, 32)
        self.iv = ArgumentRegister(self.mmio, POCA_IP_IV_OFFSET, 16)
        self.nonce = ArgumentRegister(self.mmio, POCA_IP_IV_OFFSET, 16)
        self.pt = ArgumentRegister(self.mmio, POCA_IP_PT_OFFSET, 16)
        self.ct = ArgumentRegister(self.mmio, POCA_IP_CT_OFFSET, 16)
        self.mode = ArgumentRegister(self.mmio, POCA_IP_MODE_OFFSET, 4)
        self.keysize = ArgumentRegister(self.mmio, POCA_IP_SIZE_OFFSET, 4)
        self.dir = ArgumentRegister(self.mmio, POCA_IP_DIR_OFFSET, 4)

    def write_config(self, config):
        self.length.write(config.length)
        self.key.write(config.key)
        if config.iv is not None:
            self.iv.write(config.iv)
        if config.nonce is not None:
            self.nonce.write(config.nonce)
        self.pt.write(config.pt_ptr)
        self.ct.write(config.ct_ptr)
        self.mode.write(config.mode)
        self.keysize.write(config.key_size)
        self.dir.write(config.dir)

    def write_config_fast(self, config):
        self.mmio.array[:32] = config

    
class POCAControlRegisterMediator:

    def __init__(self, interfaces):
        self.interfaces = interfaces
        self.control_registers = [i.CTRL for i in interfaces]

    def choose_available(self, config):
        parallelizable = config.mode in [0, 2] and config.length >= (10 * 1024) # 10k blocks

        if parallelizable:
            return [i for i, r in enumerate(self.control_registers) if r.is_idle()]
        else:
            return [i for i, r in enumerate(self.control_registers) if r.is_idle()][0:1]
    
    def is_done(self, chosen):
        return all([(self.control_registers[i].is_done_or_idle()) for i in chosen])
    
    def start(self, chosen):
        for i in chosen:
            self.control_registers[i].start()

    def write_config(self, chosen, config):
        split_count = len(chosen)
        split_length = config.length // split_count
        lengths = [split_length] * (split_count - 1) + [config.length - split_length * (split_count - 1)]

        if config.pt_ptrs:
            for i, r in enumerate(chosen):
                custom_config = config.build_config(
                    lengths[i],
                    config.pt_ptrs[i],
                    config.ct_ptrs[i],
                    config.dir,
                    split_length * i
                )
                self.interfaces[r].write_config_fast(custom_config)
                self.interfaces[r].mmio.array[0] = 1
        else:
            for i, r in enumerate(chosen):
                custom_config = config.build_config(
                    lengths[i],
                    config.pt_ptr + (split_length * 16) * i,
                    config.ct_ptr + (split_length * 16) * i,
                    config.dir,
                    split_length * i
                )
                self.interfaces[r].write_config_fast(custom_config)
                self.interfaces[r].mmio.array[0] = 1  
            

class POCAInterfaceMediator:

    def __init__(self, count):
        self.interfaces = [POCAInterface(i) for i in range(count)]
        self.CTRL = POCAControlRegisterMediator(self.interfaces)
        self.count = count

    def overclock(self):
        from pynq import Clocks

        Clocks.fclk0_mhz = POCA_MAX_FREQ[self.count - 1]

    def choose_available(self, config):
        return self.CTRL.choose_available(config)
    
    def is_done(self, chosen):
        return self.CTRL.is_done(chosen)
    
    def start(self, chosen):
        self.CTRL.start(chosen)

    def write_config(self, chosen, config):
        self.CTRL.write_config(chosen, config)
