#ifndef UTIL_H_INCLUDED
#define UTIL_H_INCLUDED

#include <stdint.h>

uint64_t perf_counter_ns();

void get_random_data(char *, uint32_t);
void fromhex_inplace(char *);

#endif
