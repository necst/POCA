// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xpoca_main.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XPoca_main_CfgInitialize(XPoca_main *InstancePtr, XPoca_main_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XPoca_main_Start(XPoca_main *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_AP_CTRL) & 0x80;
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XPoca_main_IsDone(XPoca_main *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XPoca_main_IsIdle(XPoca_main *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XPoca_main_IsReady(XPoca_main *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XPoca_main_EnableAutoRestart(XPoca_main *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XPoca_main_DisableAutoRestart(XPoca_main *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_AP_CTRL, 0);
}

void XPoca_main_Set_length_r(XPoca_main *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_LENGTH_R_DATA, Data);
}

u32 XPoca_main_Get_length_r(XPoca_main *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_LENGTH_R_DATA);
    return Data;
}

void XPoca_main_Set_key(XPoca_main *InstancePtr, XPoca_main_Key Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 0, Data.word_0);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 4, Data.word_1);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 8, Data.word_2);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 12, Data.word_3);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 16, Data.word_4);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 20, Data.word_5);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 24, Data.word_6);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 28, Data.word_7);
}

XPoca_main_Key XPoca_main_Get_key(XPoca_main *InstancePtr) {
    XPoca_main_Key Data;

    Data.word_0 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 0);
    Data.word_1 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 4);
    Data.word_2 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 8);
    Data.word_3 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 12);
    Data.word_4 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 16);
    Data.word_5 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 20);
    Data.word_6 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 24);
    Data.word_7 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_KEY_DATA + 28);
    return Data;
}

void XPoca_main_Set_iv_or_nonce(XPoca_main *InstancePtr, XPoca_main_Iv_or_nonce Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IV_OR_NONCE_DATA + 0, Data.word_0);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IV_OR_NONCE_DATA + 4, Data.word_1);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IV_OR_NONCE_DATA + 8, Data.word_2);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IV_OR_NONCE_DATA + 12, Data.word_3);
}

XPoca_main_Iv_or_nonce XPoca_main_Get_iv_or_nonce(XPoca_main *InstancePtr) {
    XPoca_main_Iv_or_nonce Data;

    Data.word_0 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IV_OR_NONCE_DATA + 0);
    Data.word_1 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IV_OR_NONCE_DATA + 4);
    Data.word_2 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IV_OR_NONCE_DATA + 8);
    Data.word_3 = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IV_OR_NONCE_DATA + 12);
    return Data;
}

void XPoca_main_Set_plaintext(XPoca_main *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_PLAINTEXT_DATA, (u32)(Data));
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_PLAINTEXT_DATA + 4, (u32)(Data >> 32));
}

u64 XPoca_main_Get_plaintext(XPoca_main *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_PLAINTEXT_DATA);
    Data += (u64)XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_PLAINTEXT_DATA + 4) << 32;
    return Data;
}

void XPoca_main_Set_ciphertext(XPoca_main *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHERTEXT_DATA, (u32)(Data));
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHERTEXT_DATA + 4, (u32)(Data >> 32));
}

u64 XPoca_main_Get_ciphertext(XPoca_main *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHERTEXT_DATA);
    Data += (u64)XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHERTEXT_DATA + 4) << 32;
    return Data;
}

void XPoca_main_Set_cipher_mode(XPoca_main *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHER_MODE_DATA, Data);
}

u32 XPoca_main_Get_cipher_mode(XPoca_main *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHER_MODE_DATA);
    return Data;
}

void XPoca_main_Set_cipher_keysize(XPoca_main *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHER_KEYSIZE_DATA, Data);
}

u32 XPoca_main_Get_cipher_keysize(XPoca_main *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHER_KEYSIZE_DATA);
    return Data;
}

void XPoca_main_Set_cipher_direction(XPoca_main *InstancePtr, u32 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHER_DIRECTION_DATA, Data);
}

u32 XPoca_main_Get_cipher_direction(XPoca_main *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_CIPHER_DIRECTION_DATA);
    return Data;
}

void XPoca_main_InterruptGlobalEnable(XPoca_main *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_GIE, 1);
}

void XPoca_main_InterruptGlobalDisable(XPoca_main *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_GIE, 0);
}

void XPoca_main_InterruptEnable(XPoca_main *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IER);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IER, Register | Mask);
}

void XPoca_main_InterruptDisable(XPoca_main *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IER);
    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IER, Register & (~Mask));
}

void XPoca_main_InterruptClear(XPoca_main *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XPoca_main_WriteReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_ISR, Mask);
}

u32 XPoca_main_InterruptGetEnabled(XPoca_main *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_IER);
}

u32 XPoca_main_InterruptGetStatus(XPoca_main *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XPoca_main_ReadReg(InstancePtr->Control_BaseAddress, XPOCA_MAIN_CONTROL_ADDR_ISR);
}

