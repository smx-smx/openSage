#ifndef __BIGFILE_H
#define __BIGFILE_H

#include <stdint.h>

#define BIG_MAGIC1 "BIGF"
#define BIG_MAGIC2 "BIG4"

typedef struct __attribute__((packed)){
	uint32_t offset;
	uint32_t length;
	char name[];
} BigEntry;

typedef struct __attribute__((packed)){
	char magic[4];
	uint32_t size;
	uint32_t n_files;
	uint32_t offset;
	BigEntry entries[];
} BigHeader;

#endif