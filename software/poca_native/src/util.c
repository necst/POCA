#include "util.h"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

__attribute__((always_inline))
uint64_t perf_counter_ns()
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (uint64_t)ts.tv_sec * 1000000000 + (uint64_t)ts.tv_nsec;
}

void get_random_data(char *dst, uint32_t size)
{
    int fd = open("/dev/urandom", O_RDONLY);
    if (fd < 0) {
        perror("open");
        exit(1);
    }

    int64_t ret = read(fd, dst, size);
    if (ret < 0) {
        perror("read");
        exit(1);
    }

    if (ret != size) {
        fprintf(stderr, "read: short read: %zd < %d\n", ret, size);
        
        ret += read(fd, dst + ret, size - ret);

        if (ret != size)
            exit(1);
    }

    close(fd);

    return;
}

void fromhex_inplace(char *ptr)
{
    uint32_t size = strlen(ptr);
    if (size % 2 != 0) {
        fprintf(stderr, "fromhex_inplace: invalid size: %d\n", size);
        exit(1);
    }

    for (uint32_t i = 0; i < size; i += 2) {
        char c = ptr[i];
        if (c >= '0' && c <= '9') {
            c -= '0';
        } else if (c >= 'a' && c <= 'f') {
            c -= 'a' - 10;
        } else if (c >= 'A' && c <= 'F') {
            c -= 'A' - 10;
        } else {
            fprintf(stderr, "fromhex_inplace: invalid char: %c\n", c);
            exit(1);
        }

        char d = ptr[i + 1];
        if (d >= '0' && d <= '9') {
            d -= '0';
        } else if (d >= 'a' && d <= 'f') {
            d -= 'a' - 10;
        } else if (d >= 'A' && d <= 'F') {
            d -= 'A' - 10;
        } else {
            fprintf(stderr, "fromhex_inplace: invalid char: %c\n", d);
            exit(1);
        }

        ptr[i / 2] = (c << 4) | d;
    }

    for (uint32_t i = size / 2; i < size; i++) {
        ptr[i] = 0;
    }
}
