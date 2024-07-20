# POCA: a PYNQ Offloaded Cryptographic Accelerator on Embedded FPGA-based Systems

This repository contains the source code of POCA, an FPGA-based symmetric cryptographic accelerator.
Our hardware-software overlay exposes a set of standard cryptographic primitives to the user, which can be easily integrated into more complex applications thanks to the provided Python and C APIs.
Additionally, our cross-platform compatible software implementations automatically handle workload distribution between all the available hardware cores of the specific target, ensuring optimal performance and energy efficiency.

## Table of Contents
- `hardware/`: Contains the various hardware design sources for the POCA accelerator, including the block designs, the custom lightweight AES cipher implementation, and the POCA hardware IP.
- `software/`: Contains the software sources for the POCA accelerator, including the Python and C APIs. The provided sources include the necessary bitstreams and are configured for the Ultra96v2 platform, but they can be easily modified to target other platforms.

Refer to the subdirectory README files for more detailed information on the hardware and software components.


If you find this repository useful, please use the following citation:

```
@inproceedings{bertolini2024pocaraw,
  title={POCA: a PYNQ Offloaded Cryptographic Accelerator on Embedded FPGA-based Systems},
 author={Bertolini, Roberto A. and Carloni, Filippo and Conficconi, Davide and Santambrogio, Marco D.},
  booktitle={IEEE International Parallel and Distributed Processing Symposium Workshops (IPDPSW)},
  year={2024},
  note ="Accepted - To Appear"
}
```
