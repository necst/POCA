#ifndef POCA_H_INCLUDED
#define POCA_H_INCLUDED

#include "experimental/xrt_bo.h"
#include "experimental/xrt_device.h"

struct poca_axilite_data {
    void *base_ptr;
    uint32_t length;
    uint8_t key[32], iv[16];
    char *pt, *ct;
    uint32_t mode, size, direction;
};

struct poca_ip {
    xclBufferHandle encryption_buffer;
    xclBufferHandle decryption_buffer;
    char *encryption_buffer_ptr;
    char *decryption_buffer_ptr;
    struct poca_axilite_data axilite_data;
};

struct poca {
    uint32_t ip_count;
    xclDeviceHandle device_handle;
    uint32_t data_size;
    struct poca_ip *ip;
};

void load_bitstream();
struct poca *create_poca_instance(uint32_t);
void allocate_buffers(struct poca *);
void free_poca_instance(struct poca *);
void set_key(struct poca *, char *);
void set_iv(struct poca *, char *);
void set_params(struct poca *, uint32_t, uint32_t, uint32_t);
void *open_device();

void write_input_to_buffers(struct poca *, char *);
void read_output_from_buffers(struct poca *, char *);
void poca_write_to_axilite(struct poca_axilite_data *);
void poca_write_args_to_ip(struct poca *);
void poca_start(struct poca *);
uint32_t poca_done_or_idle(struct poca *);

#endif
