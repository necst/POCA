# Hardware

This directory contains all the hardware-related files of the POCA project:
- `internal_aes_core`: VHDL source code for the internal AES core that POCA implements.
- `poca_ultra96_ip`: Vivado IP package for the POCA core for the Ultra96 board.
- `poca_z2_ip`: Vivado IP package for the POCA core for the Z2 board.
- `poca_ultra96_vivado`: Vivado project for the POCA core for the Ultra96 board, with the block designs for the single-core and six-core configurations.

To recreate the Vivado project, please run the `poca_ultra96_vivado.tcl` script in the `poca_ultra96_vivado` folder.
