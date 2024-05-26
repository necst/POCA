#include <argp.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#include "poca.h"
#include "util.h"

#define DEBUG 0

const char *argp_program_version = "POCA 1.0.0";
const char *argp_program_address = "robertoalessandro.bertolini@mail.polimi.it";
static char doc[] = "POCA - PYNQ Offloaded Cryptographic Accelerator";
static char args_doc[] = "OPERATION";
const struct argp_option options[] = {
    {"size", 's', "SIZE", 0, "Data size"},
    {"input", 'i', "INPUT", 0, "Input file"},
    {"output", 'o', "OUTPUT", 0, "Output file"},
    {"key", 'k', "KEY", 0, "Encryption key"},
    {"iv", 'v', "IV", 0, "Initialization vector"},
    {"mode", 'm', "MODE", 0, "Encryption mode"},
    {"direction", 'd', "DIRECTION", 0, "Encryption direction"},
    {"ip_count", 'c', "IPCOUNT", 0, "IP Count"},
    { 0 }
};

struct arguments {
    char *args[1];
    uint32_t size;
    char *input;
    char *output;
    char *key;
    char *iv;
    uint32_t mode;
    uint32_t direction;
    uint32_t ip_count;
};

static error_t parse_opt(int key, char *arg, struct argp_state *state)
{
    struct arguments *arguments = state->input;
    switch (key) {
        case 's':
            arguments->size = atoi(arg);
            break;
        case 'i':
            arguments->input = arg;
            break;
        case 'o':
            arguments->output = arg;
            break;
        case 'k':
            arguments->key = arg;
            break;
        case 'v':
            arguments->iv = arg;
            break;
        case 'm':
            arguments->mode = atoi(arg);
            break;
        case 'd':
            arguments->direction = atoi(arg);
            break;
        case 'c':
            arguments->ip_count = atoi(arg);
            break;
        case ARGP_KEY_ARG:
            if (state->arg_num >= 1) {
                argp_usage(state);
            }
            arguments->args[state->arg_num] = arg;
            break;
        case ARGP_KEY_END:
            if (state->arg_num < 1) {
                argp_usage(state);
            }
            break;
        default:
            return ARGP_ERR_UNKNOWN;
    }
    return 0;
}

static struct argp argp = { options, parse_opt, args_doc, doc };

void sig_handler(int signum)
{
    if (signum == SIGALRM) {
        printf("Timeout\n");
        exit(EXIT_FAILURE);
    }
}

void get_input_data(char *buffer, char *file_name, uint32_t size)
{
    FILE *file = fopen(file_name, "rb");
    if (file == NULL) {
        printf("ERROR: Could not open input file\n");
        exit(EXIT_FAILURE);
    }
    if (fread(buffer, 1, size, file) != size) {
        printf("ERROR: Could not read input file\n");
        exit(EXIT_FAILURE);
    }
    fclose(file);
}

void write_output_data(char *buffer, char *file_name, uint32_t size)
{
    FILE *file = fopen(file_name, "wb");
    if (file == NULL) {
        printf("ERROR: Could not open output file\n");
        exit(EXIT_FAILURE);
    }
    fwrite(buffer, 1, size, file);
    fclose(file);
}

int main(int argc, char *argv[])
{
    signal(SIGALRM, sig_handler);
    alarm(30);

    struct arguments arguments = { 0 };

    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    if (strcmp(arguments.args[0], "encrypt") != 0
         && strcmp(arguments.args[0], "decrypt") != 0
         && strcmp(arguments.args[0], "benchmark") != 0) {
        printf("ERROR: Unrecognized program mode\n");
        return EXIT_FAILURE;
    }

    if (!DEBUG && arguments.size <= 0x4000) {
        arguments.ip_count = 1;
    }

    load_bitstream(arguments.ip_count);

    if (DEBUG)
        puts("Loaded bitstream");

    struct poca *instance = create_poca_instance(arguments.ip_count);

    if (DEBUG) {
        printf("Size: %u\n", arguments.size);
        printf("Input: %s\n", arguments.input);
        printf("Output: %s\n", arguments.output);
        printf("Key: %s\n", arguments.key);
        printf("IV: %s\n", arguments.iv);
        printf("Mode: %u\n", arguments.mode);
        printf("Direction: %u\n", arguments.direction);
        printf("IP Count: %u\n", arguments.ip_count);
        printf("Program Mode: %s\n", arguments.args[0]);
    }

    instance->data_size = arguments.size / 16;
    allocate_buffers(instance);

    uint32_t keylen = strlen(arguments.key) == 32 ? 0 : 2;
    fromhex_inplace(arguments.key);
    fromhex_inplace(arguments.iv);

    set_key(instance, arguments.key);
    set_iv(instance, arguments.iv);
    set_params(instance, arguments.mode, keylen, arguments.direction);

    char *input = malloc(arguments.size);
    if (strcmp(arguments.args[0], "benchmark") == 0) {
        memset(input, 0, arguments.size);
        // get_random_data(input, arguments.size);
    } else {
        get_input_data(input, arguments.input, arguments.size);
    }

    uint64_t start_time = 0, end_time = 0;

    if (strcmp(arguments.args[0], "benchmark") == 0) {
        write_input_to_buffers(instance, input);
        poca_write_args_to_ip(instance);

        for (int i = 0; i < 20; i++) {
            start_time = perf_counter_ns();

            poca_start(instance);
            while (!poca_done_or_idle(instance));          

            end_time = perf_counter_ns();

            printf("%lu\n", end_time - start_time);
        }
    } else {
        write_input_to_buffers(instance, input);
        poca_write_args_to_ip(instance);

        if (DEBUG) start_time = perf_counter_ns();

        poca_start(instance);
        while (!poca_done_or_idle(instance));

        if (DEBUG) end_time = perf_counter_ns();
    }

    if (DEBUG)
        printf("Elapsed time: %lu ns\n", end_time - start_time);

    read_output_from_buffers(instance, input);

    if (DEBUG) {
        for (int i = 0; i < 96; i++) {
            printf("%02x", input[i]);
        }
        printf("\n");
    }

    if (strcmp(arguments.args[0], "benchmark")) {
        write_output_data(input, arguments.output, arguments.size);
    }

    free(input);

    free_poca_instance(instance);

    return EXIT_SUCCESS;
}
