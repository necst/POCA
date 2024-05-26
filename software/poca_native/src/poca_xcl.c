#include <stdio.h>

#include "experimental/xrt_bo.h"
#include "experimental/xrt_device.h"
#include "experimental/xrt_kernel.h"
#include "poca_xcl.h"

xclDeviceHandle xclOpenDevice()
{
    xclDeviceHandle device_handle;
    device_handle = xclOpen(0, NULL, 0);

    if (!device_handle) {
        printf("ERROR: Failed to open device\n");
        return NULL;
    }

    return device_handle;
}

void xclCloseDevice(xclDeviceHandle device)
{
    xclClose(device);
}

xclBufferHandle xclAllocate(xclDeviceHandle device, uint32_t size)
{
    xclBufferHandle buffer;
    buffer = xclAllocBO(device, size, XCL_BO_DEVICE_RAM, 0);

    return buffer;
}

void xclFree(xclDeviceHandle device, xclBufferHandle buffer)
{
    if (buffer)
        xclFreeBO(device, buffer);
}

void *getBufferPhysicalAddress(xclDeviceHandle device, xclBufferHandle buffer)
{
    struct xclBOProperties props;
    xclGetBOProperties(device, buffer, &props);

    if (props.paddr >= 0x80000000) {
        printf("ERROR: Memory allocation did not success\n");
        exit(1);
    }

    return (void *)props.paddr;
}

char *xclMapBuffer(xclDeviceHandle device, xclBufferHandle buffer)
{
    char *buffer_ptr;
    buffer_ptr = xclMapBO(device, buffer, true);

    if (buffer_ptr == NULL) {
        printf("ERROR: Failed to map BO buffer\n");
        exit(1);
    }

    return buffer_ptr;
}

void xclUnmapBuffer(xclDeviceHandle device, xclBufferHandle buffer, char *buffer_ptr)
{
    xclUnmapBO(device, buffer, buffer_ptr);
}

void xclFlush(xclDeviceHandle device, xclBufferHandle dest, uint32_t size)
{
    if (xclSyncBO(device, dest, XCL_BO_SYNC_BO_TO_DEVICE, size, 0)) {
        printf("ERROR: Failed to flush BO buffer\n");
        exit(1);
    }
}

void xclInvalidate(xclDeviceHandle device, xclBufferHandle src, uint32_t size)
{
    if (xclSyncBO(device, src, XCL_BO_SYNC_BO_FROM_DEVICE, size, 0)) {
        printf("ERROR: Failed to invalidate BO buffer\n");
        exit(1);
    }
}
