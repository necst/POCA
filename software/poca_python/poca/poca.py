import numpy

from .poca_utils import POCAInterfaceMediator, CipherConfiguration, BITSTREAMS_DIR
from .pynq_utils import OverlayManager


class AES:
    MODE_ECB = 0
    MODE_CBC = 1
    MODE_CTR = 2

    def __init__(self, config, parallelize=-1, overclock=True) -> None:
        if parallelize == -1:
            parallelize = 1 if config.mode == AES.MODE_CBC else 6

        if not (1 <= parallelize <= 6):
            raise ValueError('Parallelization count must be between 1 and 6')

        self.overlay_manager = OverlayManager(BITSTREAMS_DIR + f'/poca_ultra96_{parallelize}.bit')
        self.interface = POCAInterfaceMediator(parallelize)
        self.config = config
        self.parallelize = parallelize
        self.preallocated = False

        if overclock:
            self.interface.overclock()

    @staticmethod
    def new(key: bytes, mode: int, iv: bytes = None, nonce: bytes = None, parallelize: int = -1, overclock: bool = True, preallocate_buffers: bool = True, preallocate_length: int = 16 * 1024 * 1024):
        if preallocate_buffers and (preallocate_length < 16 or preallocate_length % 16 != 0):
            raise ValueError('Preallocated buffer length must be a positive multiple of 16 bytes')

        if preallocate_buffers:
            config = CipherConfiguration(mode, key, iv, nonce)
            aes = AES(config, parallelize, overclock)
            input_buffer, output_buffer = aes.preallocate_buffers(preallocate_length)
            aes.register_buffers(input_buffer, output_buffer, preallocate_length)
            return aes
        else:
            return AES(CipherConfiguration(mode, key, iv, nonce), parallelize, overclock)
        
    def allocate_array_pair(self, length):
        return self.overlay_manager.allocate_array_pair(length)
    
    def register_buffers(self, input, output, length):
        self.input_buffer = input
        self.output_buffer = output
        self.preallocated = True
        self.config.max_length = length // 16
    
    def preallocate_buffers(self, length: int):
        if length % 16 != 0:
            raise ValueError('Length must be a multiple of 16 bytes')
        
        if self.preallocated:
            raise RuntimeError('Buffers have already been preallocated. Please instantiate a new object with preallocate_buffers=False to use this feature')

        input_buffer, output_buffer = self.allocate_array_pair(length)
        self.config.length = length // 16
        self.config.pt_ptr = input_buffer.physical_address
        self.config.ct_ptr = output_buffer.physical_address
        self.config.pt_ptrs = []
        self.config.ct_ptrs = []
        return input_buffer, output_buffer

    def preallocate_buffers_large(self, length: int):
        if length % 16 != 0:
            raise ValueError('Length must be a multiple of 16 bytes')
        
        if self.preallocated:
            raise RuntimeError('Buffers have already been preallocated. Please instantiate a new object with preallocate_buffers=False to use this feature')

        self.config.length = length // 16

        self.config.pt_ptr = None
        self.config.ct_ptr = None
        
        self.config.pt_ptrs = []
        self.config.ct_ptrs = []

        buffers = []

        for i in range(self.parallelize - 1):
            buffer = self.overlay_manager.allocate(length // self.parallelize)
            buffers.append(buffer)
            self.config.pt_ptrs.append(buffer.physical_address)
            self.config.ct_ptrs.append(buffer.physical_address)

        buffer = self.overlay_manager.allocate(length - (length // self.parallelize) * (self.parallelize - 1))
        buffers.append(buffer)
        self.config.pt_ptrs.append(buffer.physical_address)
        self.config.ct_ptrs.append(buffer.physical_address)
        
        return buffers, buffers
    
    def _process(self, input: bytes | None = None, encrypt: bool = True) -> bytes | None:
        if input is not None and self.preallocated:
            length = len(input)

            if length % 16 != 0 and self.config.mode != AES.MODE_CTR:
                raise ValueError('Input length must be a multiple of 16 bytes')

            if self.config.max_length < (length // 16):
                raise ValueError('Input exceeds preallocated buffer length')
            
            self.input_buffer[:length] = numpy.frombuffer(input, numpy.uint8)

            self.config = self.config.apply(
                length // 16,
                self.input_buffer.physical_address,
                self.output_buffer.physical_address,
                0 if encrypt else 1
            )
        elif input is not None:
            length = len(input)

            if length % 16 != 0 and self.config.mode != AES.MODE_CTR:
                raise ValueError('Input length must be a multiple of 16 bytes')
            
            input_buffer, output_buffer = self.allocate_array_pair(length)
            input_buffer[:] = numpy.frombuffer(input, numpy.uint8)
        
            self.config = self.config.apply(
                length // 16,
                input_buffer.physical_address,
                output_buffer.physical_address,
                0 if encrypt else 1
            )
        else:
            if self.config.length is None:
                raise ValueError('Length must be specified if input is None')
            if self.config.pt_ptr is None and not self.config.pt_ptrs:
                raise ValueError('Input buffer must be preallocated if input is None')
            if self.config.ct_ptr is None and not self.config.ct_ptrs:
                raise ValueError('Output buffer must be preallocated if input is None')
            
            self.config.dir = 0 if encrypt else 1
    
        available = self.interface.choose_available(self.config)

        while available is None:
            available = self.interface.choose_available(self.config)

        self.interface.write_config(available, self.config)

        while not self.interface.is_done(available):
            pass

        if input is not None and self.preallocated:
            self.output_buffer.invalidate()

            return self.output_buffer.data[:length]
        elif input is not None:
            output_buffer.invalidate()
            del input_buffer

            return output_buffer[:length].tobytes()
        else:
            return None
    
    def encrypt(self, plaintext: bytes | None = None) -> bytes | None:
        return self._process(plaintext, True)

    def decrypt(self, ciphertext: bytes | None = None) -> bytes | None:
        return self._process(ciphertext, False)
    
    def ready(self) -> bool:
        return len(self.interface.choose_available(parallelizable=False)) > 0
