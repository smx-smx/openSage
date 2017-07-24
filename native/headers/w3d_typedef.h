#ifndef __W3D_TYPEDEF_H
#define __W3D_TYPEDEF_H

#include <stdint.h>

typedef struct {
	float x;
	float y;
} IOVector2Struct;

typedef struct {
	float x;
	float y;
	float z;
} IOVector3Struct;

typedef struct {
	float x;
	float y;
	float z;
	float w;
} IOQuaternionStruct;

typedef uint8_t uint8;
typedef uint16_t uint16;
typedef uint32_t uint32;
typedef int32_t sint32;
typedef float float32;

#endif
