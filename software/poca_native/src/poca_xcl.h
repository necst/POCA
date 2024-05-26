#ifndef POCA_XCL_INCLUDED_H
#define POCA_XCL_INCLUDED_H

#include "poca.h"

#include "experimental/xrt_bo.h"
#include "experimental/xrt_device.h"
#include "experimental/xrt_kernel.h"

xclDeviceHandle xclOpenDevice();
void xclCloseDevice(xclDeviceHandle);

xclBufferHandle xclAllocate(xclDeviceHandle, uint32_t);
void xclFree(xclDeviceHandle, xclBufferHandle);

void *getBufferPhysicalAddress(xclDeviceHandle, xclBufferHandle);
char *xclMapBuffer(xclDeviceHandle, xclBufferHandle);
void xclUnmapBuffer(xclDeviceHandle, xclBufferHandle, char *);
void xclFlush(xclDeviceHandle, xclBufferHandle, uint32_t);
void xclInvalidate(xclDeviceHandle, xclBufferHandle, uint32_t);

#endif
