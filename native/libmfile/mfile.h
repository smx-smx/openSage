/*
	A mmap file wrapper
	Copyright 2016 Smx
*/
#ifndef __MFILE_H
#define __MFILE_H
#include <stdio.h>
#include <stdint.h>
#include <fcntl.h>
#include <sys/stat.h>

#ifdef _WIN32
#include "win32/mman.h"
#else
#include <sys/mman.h>
#endif

/* Branch Prediction Hints */
#define LIKELY(x)    __builtin_expect (!!(x), 1)
#define UNLIKELY(x)  __builtin_expect (!!(x), 0)

#define MFILE_ANON(size) \
	mmap(0, size, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE, 0, 0)

/* Gets the path of the memory mapped file */
#define mpath(mfile) mfile->path
/* Gets the size of the memory mapped file */
#define msize(mfile) mfile->statBuf.st_size
/* Gets the data, casted to the type specified in the second argument */
#define mdata(mfile, type) (type *)(mfile->pMem)
/* Gets the file handler (for mfopen) */
#define mfh(mfile) mfile->fh
/* Gets the file offset */
#define moff(mfile, ptr) (off_t)((uintptr_t)ptr - (uintptr_t)(mfile->pMem))

#define mbytes(mfile) mdata(mfile, uint8_t)

#define mwriteat(mfile, off, ptr, size) \
	memcpy( \
		(void *)(&(mdata(mfile, uint8_t))[off]), \
		(void *)ptr, \
		size \
	)

#define mwrite(ptr, size, nmemb, mfile) \
	mwriteat( \
		mfile, \
		mfile->offset, \
		ptr, \
		(size * nmemb) \
	); \
	mfile->offset += (size * nmemb)
	
#define mrewind(mfile) mfile->offset = 0

typedef struct {
	uint8_t *ptr;
	off_t offset;
	size_t size;
} cursor_t;

typedef struct {
	char *path;
	int fd;
	FILE *fh;
	off_t offset;
	int prot;
	struct stat statBuf;
	void *pMem;
} MFILE;

MFILE *mfile_new();

void *mfile_map(MFILE *file, size_t size);
void *mfile_map_private(MFILE *file, size_t size);

MFILE *mopen(const char *path, int oflags);
MFILE *mopen_private(const char *path, int oflags);

MFILE *mfopen(const char *path, const char *mode);
MFILE *mfopen_private(const char *path, const char *mode);

int mgetc(MFILE *stream);
int mputc(int c, MFILE *stream);

int cgetc(cursor_t *stream);
int cputc(int c, cursor_t *stream);

int mclose(MFILE *mfile);
#endif
