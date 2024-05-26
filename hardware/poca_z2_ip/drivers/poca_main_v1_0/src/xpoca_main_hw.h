// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
// control
// 0x00 : Control signals
//        bit 0  - ap_start (Read/Write/COH)
//        bit 1  - ap_done (Read/COR)
//        bit 2  - ap_idle (Read)
//        bit 3  - ap_ready (Read/COR)
//        bit 7  - auto_restart (Read/Write)
//        bit 9  - interrupt (Read)
//        others - reserved
// 0x04 : Global Interrupt Enable Register
//        bit 0  - Global Interrupt Enable (Read/Write)
//        others - reserved
// 0x08 : IP Interrupt Enable Register (Read/Write)
//        bit 0 - enable ap_done interrupt (Read/Write)
//        bit 1 - enable ap_ready interrupt (Read/Write)
//        others - reserved
// 0x0c : IP Interrupt Status Register (Read/TOW)
//        bit 0 - ap_done (Read/TOW)
//        bit 1 - ap_ready (Read/TOW)
//        others - reserved
// 0x10 : Data signal of length_r
//        bit 31~0 - length_r[31:0] (Read/Write)
// 0x14 : reserved
// 0x18 : Data signal of key
//        bit 31~0 - key[31:0] (Read/Write)
// 0x1c : Data signal of key
//        bit 31~0 - key[63:32] (Read/Write)
// 0x20 : Data signal of key
//        bit 31~0 - key[95:64] (Read/Write)
// 0x24 : Data signal of key
//        bit 31~0 - key[127:96] (Read/Write)
// 0x28 : Data signal of key
//        bit 31~0 - key[159:128] (Read/Write)
// 0x2c : Data signal of key
//        bit 31~0 - key[191:160] (Read/Write)
// 0x30 : Data signal of key
//        bit 31~0 - key[223:192] (Read/Write)
// 0x34 : Data signal of key
//        bit 31~0 - key[255:224] (Read/Write)
// 0x38 : reserved
// 0x3c : Data signal of iv_or_nonce
//        bit 31~0 - iv_or_nonce[31:0] (Read/Write)
// 0x40 : Data signal of iv_or_nonce
//        bit 31~0 - iv_or_nonce[63:32] (Read/Write)
// 0x44 : Data signal of iv_or_nonce
//        bit 31~0 - iv_or_nonce[95:64] (Read/Write)
// 0x48 : Data signal of iv_or_nonce
//        bit 31~0 - iv_or_nonce[127:96] (Read/Write)
// 0x4c : reserved
// 0x50 : Data signal of plaintext
//        bit 31~0 - plaintext[31:0] (Read/Write)
// 0x54 : Data signal of plaintext
//        bit 31~0 - plaintext[63:32] (Read/Write)
// 0x58 : reserved
// 0x5c : Data signal of ciphertext
//        bit 31~0 - ciphertext[31:0] (Read/Write)
// 0x60 : Data signal of ciphertext
//        bit 31~0 - ciphertext[63:32] (Read/Write)
// 0x64 : reserved
// 0x68 : Data signal of cipher_mode
//        bit 31~0 - cipher_mode[31:0] (Read/Write)
// 0x6c : reserved
// 0x70 : Data signal of cipher_keysize
//        bit 31~0 - cipher_keysize[31:0] (Read/Write)
// 0x74 : reserved
// 0x78 : Data signal of cipher_direction
//        bit 31~0 - cipher_direction[31:0] (Read/Write)
// 0x7c : reserved
// (SC = Self Clear, COR = Clear on Read, TOW = Toggle on Write, COH = Clear on Handshake)

#define XPOCA_MAIN_CONTROL_ADDR_AP_CTRL               0x00
#define XPOCA_MAIN_CONTROL_ADDR_GIE                   0x04
#define XPOCA_MAIN_CONTROL_ADDR_IER                   0x08
#define XPOCA_MAIN_CONTROL_ADDR_ISR                   0x0c
#define XPOCA_MAIN_CONTROL_ADDR_LENGTH_R_DATA         0x10
#define XPOCA_MAIN_CONTROL_BITS_LENGTH_R_DATA         32
#define XPOCA_MAIN_CONTROL_ADDR_KEY_DATA              0x18
#define XPOCA_MAIN_CONTROL_BITS_KEY_DATA              256
#define XPOCA_MAIN_CONTROL_ADDR_IV_OR_NONCE_DATA      0x3c
#define XPOCA_MAIN_CONTROL_BITS_IV_OR_NONCE_DATA      128
#define XPOCA_MAIN_CONTROL_ADDR_PLAINTEXT_DATA        0x50
#define XPOCA_MAIN_CONTROL_BITS_PLAINTEXT_DATA        64
#define XPOCA_MAIN_CONTROL_ADDR_CIPHERTEXT_DATA       0x5c
#define XPOCA_MAIN_CONTROL_BITS_CIPHERTEXT_DATA       64
#define XPOCA_MAIN_CONTROL_ADDR_CIPHER_MODE_DATA      0x68
#define XPOCA_MAIN_CONTROL_BITS_CIPHER_MODE_DATA      32
#define XPOCA_MAIN_CONTROL_ADDR_CIPHER_KEYSIZE_DATA   0x70
#define XPOCA_MAIN_CONTROL_BITS_CIPHER_KEYSIZE_DATA   32
#define XPOCA_MAIN_CONTROL_ADDR_CIPHER_DIRECTION_DATA 0x78
#define XPOCA_MAIN_CONTROL_BITS_CIPHER_DIRECTION_DATA 32

