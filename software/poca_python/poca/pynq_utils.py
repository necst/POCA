import json
import numpy
import os
from pynq import Overlay
from pynq.pl_server import Device
from pynq.pl_server.embedded_device import EmbeddedXrtMemory
from pynq.pl_server.global_state import STATE_DIR

class ControlRegister:

    def __init__(self, mmio, offset):
        self.mmio = mmio
        self.offset = offset

    def state(self):
        state = self.mmio.read(self.offset)
        ap_start = (state & 0x1)
        ap_done = (state & 0x2) >> 1
        ap_idle = (state & 0x4) >> 2
        ap_ready = (state & 0x8) >> 3
        return (ap_start, ap_done, ap_idle, ap_ready)
    
    def start(self):
        self.mmio.write(self.offset, 0x1)

    def is_started(self):
        return self.state()[0]

    def is_done(self):
        return self.state()[1]
    
    def is_idle(self):
        return self.state()[2]
    
    def is_done_or_idle(self):
        return self.state()[1] or self.state()[2]
    
    def is_ready(self):
        return self.state()[3]

    def __repr__(self) -> str:
        return "CTRL(AP_START={}, AP_DONE={}, AP_IDLE={}, AP_READY={})".format(*self.state())


class ArgumentRegister:

    def __init__(self, mmio, offset, size):
        self.mmio = mmio
        self.offset = offset
        self.size = size

    def write(self, data):
        for i in range(0, self.size, 4):
            self.mmio.write(self.offset + i, (data >> (i * 8)) & 0xFFFFFFFF)

    def read(self):
        data = 0
        for i in range(0, self.size, 4):
            data |= self.mmio.read(self.offset + i) << (i * 8)
        return data

# Pynq is slow, as it computes the hash of the bitstream every time it is loaded.
# This class is a workaround to avoid this overhead.
class OverlayManager:

    def __init__(self, bitfile):
        self.bitfile = bitfile
        self.load_global_state()
        self.ensure_loaded()
        self.memory = MemoryManager(self.global_state)

    def ensure_loaded(self):
        if not 'bitfile_name' in self.global_state:
            self.force_load()
        elif self.global_state['bitfile_name'] != self.bitfile:
            self.force_load()

        self.load_global_state()

    def force_load(self):
        Overlay(self.bitfile, download=True)

    def load_global_state(self):
        if not os.path.exists(STATE_DIR + '/global_pl_state.json'):
            self.global_state = {}
        else:
            with open(STATE_DIR + '/global_pl_state.json', 'r') as state:
                self.global_state = json.load(state)

    def allocate(self, size):
        return self.memory.allocate(size, numpy.uint8)
    
    def allocate_array_pair(self, size):
        return self.allocate(size), self.allocate(size)


class MemoryManager:

    def __init__(self, global_state):
        self.memory = EmbeddedXrtMemory(Device.active_device, global_state['psddr'])

    def allocate(self, size, type):
        return self.memory.allocate(size, type)
