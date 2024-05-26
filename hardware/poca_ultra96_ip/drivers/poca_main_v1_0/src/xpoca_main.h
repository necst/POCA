// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1.1 (64-bit)
// Tool Version Limit: 2023.06
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef XPOCA_MAIN_H
#define XPOCA_MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files *********************************/
#ifndef __linux__
#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xil_io.h"
#else
#include <stdint.h>
#include <assert.h>
#include <dirent.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stddef.h>
#endif
#include "xpoca_main_hw.h"

/**************************** Type Definitions ******************************/
#ifdef __linux__
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
#else
typedef struct {
    u16 DeviceId;
    u64 Control_BaseAddress;
} XPoca_main_Config;
#endif

typedef struct {
    u64 Control_BaseAddress;
    u32 IsReady;
} XPoca_main;

typedef u32 word_type;

typedef struct {
    u32 word_0;
    u32 word_1;
    u32 word_2;
    u32 word_3;
    u32 word_4;
    u32 word_5;
    u32 word_6;
    u32 word_7;
} XPoca_main_Key;

typedef struct {
    u32 word_0;
    u32 word_1;
    u32 word_2;
    u32 word_3;
} XPoca_main_Iv_or_nonce;

/***************** Macros (Inline Functions) Definitions *********************/
#ifndef __linux__
#define XPoca_main_WriteReg(BaseAddress, RegOffset, Data) \
    Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))
#define XPoca_main_ReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))
#else
#define XPoca_main_WriteReg(BaseAddress, RegOffset, Data) \
    *(volatile u32*)((BaseAddress) + (RegOffset)) = (u32)(Data)
#define XPoca_main_ReadReg(BaseAddress, RegOffset) \
    *(volatile u32*)((BaseAddress) + (RegOffset))

#define Xil_AssertVoid(expr)    assert(expr)
#define Xil_AssertNonvoid(expr) assert(expr)

#define XST_SUCCESS             0
#define XST_DEVICE_NOT_FOUND    2
#define XST_OPEN_DEVICE_FAILED  3
#define XIL_COMPONENT_IS_READY  1
#endif

/************************** Function Prototypes *****************************/
#ifndef __linux__
int XPoca_main_Initialize(XPoca_main *InstancePtr, u16 DeviceId);
XPoca_main_Config* XPoca_main_LookupConfig(u16 DeviceId);
int XPoca_main_CfgInitialize(XPoca_main *InstancePtr, XPoca_main_Config *ConfigPtr);
#else
int XPoca_main_Initialize(XPoca_main *InstancePtr, const char* InstanceName);
int XPoca_main_Release(XPoca_main *InstancePtr);
#endif

void XPoca_main_Start(XPoca_main *InstancePtr);
u32 XPoca_main_IsDone(XPoca_main *InstancePtr);
u32 XPoca_main_IsIdle(XPoca_main *InstancePtr);
u32 XPoca_main_IsReady(XPoca_main *InstancePtr);
void XPoca_main_EnableAutoRestart(XPoca_main *InstancePtr);
void XPoca_main_DisableAutoRestart(XPoca_main *InstancePtr);

void XPoca_main_Set_length_r(XPoca_main *InstancePtr, u32 Data);
u32 XPoca_main_Get_length_r(XPoca_main *InstancePtr);
void XPoca_main_Set_key(XPoca_main *InstancePtr, XPoca_main_Key Data);
XPoca_main_Key XPoca_main_Get_key(XPoca_main *InstancePtr);
void XPoca_main_Set_iv_or_nonce(XPoca_main *InstancePtr, XPoca_main_Iv_or_nonce Data);
XPoca_main_Iv_or_nonce XPoca_main_Get_iv_or_nonce(XPoca_main *InstancePtr);
void XPoca_main_Set_plaintext(XPoca_main *InstancePtr, u64 Data);
u64 XPoca_main_Get_plaintext(XPoca_main *InstancePtr);
void XPoca_main_Set_ciphertext(XPoca_main *InstancePtr, u64 Data);
u64 XPoca_main_Get_ciphertext(XPoca_main *InstancePtr);
void XPoca_main_Set_cipher_mode(XPoca_main *InstancePtr, u32 Data);
u32 XPoca_main_Get_cipher_mode(XPoca_main *InstancePtr);
void XPoca_main_Set_cipher_keysize(XPoca_main *InstancePtr, u32 Data);
u32 XPoca_main_Get_cipher_keysize(XPoca_main *InstancePtr);
void XPoca_main_Set_cipher_direction(XPoca_main *InstancePtr, u32 Data);
u32 XPoca_main_Get_cipher_direction(XPoca_main *InstancePtr);

void XPoca_main_InterruptGlobalEnable(XPoca_main *InstancePtr);
void XPoca_main_InterruptGlobalDisable(XPoca_main *InstancePtr);
void XPoca_main_InterruptEnable(XPoca_main *InstancePtr, u32 Mask);
void XPoca_main_InterruptDisable(XPoca_main *InstancePtr, u32 Mask);
void XPoca_main_InterruptClear(XPoca_main *InstancePtr, u32 Mask);
u32 XPoca_main_InterruptGetEnabled(XPoca_main *InstancePtr);
u32 XPoca_main_InterruptGetStatus(XPoca_main *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif
