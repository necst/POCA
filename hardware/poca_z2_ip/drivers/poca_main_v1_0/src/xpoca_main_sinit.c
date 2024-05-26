// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.1 (64-bit)
// Tool Version Limit: 2023.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#include "xparameters.h"
#include "xpoca_main.h"

extern XPoca_main_Config XPoca_main_ConfigTable[];

XPoca_main_Config *XPoca_main_LookupConfig(u16 DeviceId) {
	XPoca_main_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XPOCA_MAIN_NUM_INSTANCES; Index++) {
		if (XPoca_main_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XPoca_main_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XPoca_main_Initialize(XPoca_main *InstancePtr, u16 DeviceId) {
	XPoca_main_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XPoca_main_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XPoca_main_CfgInitialize(InstancePtr, ConfigPtr);
}

#endif

