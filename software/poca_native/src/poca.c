#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/wait.h>

#include "poca.h"
#include "poca_xcl.h"

#define DEBUG 0

// IMPORTANT: change this file to match the generated Vivado hardware specification
#define POCA_BASE_ADDR              0xA0000000
#define POCA_IP_CTRL_OFFSET         0x0
#define POCA_IP_LEN_OFFSET          0x10
#define POCA_IP_KEY_OFFSET          0x18
#define POCA_IP_IV_OFFSET           0x3C
#define POCA_IP_PT_OFFSET           0x50
#define POCA_IP_CT_OFFSET           0x5C
#define POCA_IP_MODE_OFFSET         0x68
#define POCA_IP_SIZE_OFFSET         0x70
#define POCA_IP_DIR_OFFSET          0x78

#define REUSE_BUFFER                1


struct poca *create_poca_instance(uint32_t ip_count)
{
    struct poca *instance = malloc(sizeof(struct poca));
    instance->device_handle = xclOpenDevice();

    instance->ip_count = ip_count;
    instance->ip = malloc(ip_count * sizeof(struct poca_ip));

    void *base_ptr = open_device();

    for (uint32_t i = 0; i < ip_count; i++) {
        instance->ip[i].axilite_data.base_ptr = (void*)(base_ptr + (uint64_t)(i * 0x10000));
    }

    return instance;
}

static void ensure_bitstream_loaded(uint32_t ip_count)
{
    char argv1[] = "/usr/local/share/pynq-venv/bin/python3";
    char argv2[] = "-c";
    char argv3[] = "from pynq import Overlay, Clocks; Overlay('./bitstreams/poca_ultra96_6.bit'); Clocks.fclk0_mhz = 300;";
    char *argv[] = {argv1, argv2, argv3, NULL};
    close(0);
    close(1);
    execvp(argv[0], argv);
}

void load_bitstream(uint32_t ip_count)
{
    pid_t pid = fork();
    if (!pid) {
        ensure_bitstream_loaded(ip_count);
        return;
    }
    waitpid(pid, NULL, 0);
}

void allocate_buffers(struct poca *poca)
{
    uint32_t remainder = poca->data_size;

    for (uint32_t i = 0; i < poca->ip_count; i++) {
        uint32_t size = remainder / (poca->ip_count - i);
        remainder -= size;

        poca->ip[i].encryption_buffer = xclAllocate(poca->device_handle, size * 16);
        if (!REUSE_BUFFER)
            poca->ip[i].decryption_buffer = xclAllocate(poca->device_handle, size * 16);
        else
            poca->ip[i].decryption_buffer = poca->ip[i].encryption_buffer;

        poca->ip[i].axilite_data.pt = getBufferPhysicalAddress(poca->device_handle, poca->ip[i].encryption_buffer);
        poca->ip[i].axilite_data.ct = getBufferPhysicalAddress(poca->device_handle, poca->ip[i].decryption_buffer);

        poca->ip[i].encryption_buffer_ptr = xclMapBuffer(poca->device_handle, poca->ip[i].encryption_buffer);
        if (!REUSE_BUFFER)
            poca->ip[i].decryption_buffer_ptr = xclMapBuffer(poca->device_handle, poca->ip[i].decryption_buffer);
        else
            poca->ip[i].decryption_buffer_ptr = poca->ip[i].encryption_buffer_ptr;

        poca->ip[i].axilite_data.length = size;
    }
}

void set_key(struct poca *poca, char *key)
{
    for (uint32_t i = 0; i < poca->ip_count; i++) {
        memcpy(poca->ip[i].axilite_data.key, key, 32);
    }
}

void set_iv(struct poca *poca, char *iv)
{
    for (uint32_t i = 0; i < poca->ip_count; i++) {
        memcpy(poca->ip[i].axilite_data.iv, iv, 16);
    }
}

void set_params(struct poca *poca, uint32_t mode, uint32_t size, uint32_t direction)
{
    for (uint32_t i = 0; i < poca->ip_count; i++) {
        poca->ip[i].axilite_data.mode = mode;
        poca->ip[i].axilite_data.size = size;
        poca->ip[i].axilite_data.direction = direction;
    }
}

void free_poca_instance(struct poca *poca)
{
    for (uint32_t index = 0; index < poca->ip_count; index++) {
        xclUnmapBuffer(poca->device_handle, poca->ip[index].encryption_buffer, poca->ip[index].encryption_buffer_ptr);
        if (!REUSE_BUFFER)
            xclUnmapBuffer(poca->device_handle, poca->ip[index].decryption_buffer, poca->ip[index].decryption_buffer_ptr);

        xclFree(poca->device_handle, poca->ip[index].encryption_buffer);
        if (!REUSE_BUFFER)
            xclFree(poca->device_handle, poca->ip[index].decryption_buffer);

        poca->ip[index].encryption_buffer = (xclBufferHandle)0;
        poca->ip[index].decryption_buffer = (xclBufferHandle)0;
    }

    xclCloseDevice(poca->device_handle);

    munmap(poca->ip[0].axilite_data.base_ptr, 0x100000);
    free(poca->ip);
    free(poca);
}

void* open_device()
{
    int fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        printf("Error opening /dev/mem\n");
        exit(1);
    }

    void *base_ptr = mmap(NULL, 0x100000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, POCA_BASE_ADDR);
    if (base_ptr == MAP_FAILED) {
        printf("Error mapping memory\n");
        exit(1);
    }

#if DEBUG
    printf("Mapped memory at %p\n", base_ptr);
#endif 

    close(fd);

    return base_ptr;
}

void write_input_to_buffers(struct poca *poca, char *input)
{
    uint32_t offset = 0;

    for (uint32_t i = 0; i < poca->ip_count; i++) {
        uint32_t size = poca->ip[i].axilite_data.length * 16;
        memcpy(poca->ip[i].encryption_buffer_ptr, input + offset, size);
        offset += size;
    }

    for (uint32_t i = 0; i < poca->ip_count; i++)
        xclFlush(poca->device_handle, poca->ip[i].encryption_buffer, poca->ip[i].axilite_data.length * 16);
}

void read_output_from_buffers(struct poca *poca, char *output)
{
    uint32_t offset = 0;

    for (uint32_t i = 0; i < poca->ip_count; i++)
        xclInvalidate(poca->device_handle, poca->ip[i].decryption_buffer, poca->ip[i].axilite_data.length * 16);

    for (uint32_t i = 0; i < poca->ip_count; i++) {
        uint32_t size = poca->ip[i].axilite_data.length * 16;
        memcpy(output + offset, poca->ip[i].decryption_buffer_ptr, size);
        offset += size;
    }
}

void poca_write_args_to_ip(struct poca *poca)
{
    for (uint32_t i = 0; i < poca->ip_count; i++) {
        poca_write_to_axilite(&poca->ip[i].axilite_data);
    }
}

void poca_write_to_axilite(struct poca_axilite_data *data)
{
    void *base_ptr = data->base_ptr;

    *((volatile uint32_t*)(base_ptr + POCA_IP_LEN_OFFSET)) = data->length;

    for (uint32_t i = 0; i < 32; i++) {
        *((volatile uint8_t*)(base_ptr + POCA_IP_KEY_OFFSET + i)) = data->key[i];
    }
    for (uint32_t i = 0; i < 16; i++) {
        *((volatile uint8_t*)(base_ptr + POCA_IP_IV_OFFSET + i)) = data->iv[i];
    }

    *((volatile uint32_t*)(base_ptr + POCA_IP_PT_OFFSET)) = (uint32_t) ((uint64_t)data->pt & 0xffffffff);
    *((volatile uint32_t*)(base_ptr + POCA_IP_CT_OFFSET)) = (uint32_t) ((uint64_t)data->ct & 0xffffffff);

    *((volatile uint32_t*)(base_ptr + POCA_IP_MODE_OFFSET)) = data->mode;
    *((volatile uint32_t*)(base_ptr + POCA_IP_SIZE_OFFSET)) = data->size;
    *((volatile uint32_t*)(base_ptr + POCA_IP_DIR_OFFSET)) = data->direction;

#if DEBUG
        printf("IP %p\n", base_ptr);
        printf("Length: %d\n", data->length);
        printf("Key: ");
        for (uint32_t i = 0; i < 32; i++) {
            printf("%02x", data->key[i]);
        }
        printf("\nIV: ");
        for (uint32_t i = 0; i < 16; i++) {
            printf("%02x", data->iv[i]);
        }
        printf("\nPT: %p\n", data->pt);
        printf("CT: %p\n", data->ct);
        printf("Mode: %u\n", data->mode);
        printf("Size: %u\n", data->size);
        printf("Direction: %u\n", data->direction);
#endif
}

void poca_start(struct poca *poca)
{
    volatile uint32_t* base_ptr = poca->ip[0].axilite_data.base_ptr;
    uint32_t ip_count = poca->ip_count;
    for (uint32_t i = 0; i < ip_count; i++) {
        volatile uint32_t *ptr = base_ptr + (0x10000 >> 2) * i;
        *((volatile uint32_t*)(ptr + POCA_IP_CTRL_OFFSET)) = 0x1;
    }
}

uint32_t poca_done_or_idle(struct poca *poca)
{
    uint32_t state = 0x6;
    volatile uint32_t* base_ptr = poca->ip[0].axilite_data.base_ptr;
    uint32_t ip_count = poca->ip_count;
    for (uint32_t i = 0; i < ip_count; i++) {
        volatile uint32_t *ptr = base_ptr + (0x10000 >> 2) * i;
        state &= *((volatile uint32_t*)(ptr + POCA_IP_CTRL_OFFSET)) & 0x6;
    }
    return state;
}
