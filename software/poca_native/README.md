# POCA Native
This folder contains the source code for the POCA Native library, which uses the XRT API to communicate with the POCA hardware cores.

Running `make` will build an example program that demonstrates how POCA can be used to encrypt and decrypt data of arbitrary size using any of the supported key sizes and operating modes.

## Changing the Target Platform

In order to target a different platform, the following steps are required:
1. Ensure that the XRT API and PYNQ are available on the target platform.
2. Build and export the required bitstreams for the target platform, which must be in the form of a .bit/.hwh pair.
3. Place the exported bitstream files in the `bitstreams` folder. 
4. Edit `src/poca.c` with the correct base address of the POCA hardware core.
5. Run `make` to build the example program for the target platform, and verify full functionality of the POCA library.
