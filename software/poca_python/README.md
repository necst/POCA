# POCA
POCA is a hardware accelerated library that can be used to offload AES cryptographic operations to an FPGA accelerator.
It is compatible with all the devices supported by the PYNQ environment, and comes by default with bitstreams for the Ultra96.
The API is identical to the one provided by the popular PyCryptodome library, enabling for easy integration into pre-existing software.

To install POCA, simply run:
```bash
pip install .
```

## Changing the Target Platform

In order to target a different platform, the following steps are required:
1. Ensure that PYNQ is available on the target platform.
2. Build and export the required bitstreams for the target platform. We recommend to export them in the form of a .bit/.hwh pair, as it is the fastest to load on the FPGA because it is not compressed, but any format supported by PYNQ can be used.
3. Place the exported bitstream files in the `poca/bitstreams` folder.
4. Edit `poca/poca_utils.py` with the correct base address of the POCA hardware core.
5. Run `pip install .` to install the POCA library for the target platform, and verify full functionality of the POCA library.
