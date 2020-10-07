#pragma once

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif


typedef struct 
{
    float thumb_x;
    float thumb_y;

    uint8_t up;
    uint8_t down;
    uint8_t left;
    uint8_t right;

    uint8_t a;
    uint8_t b;
    uint8_t x;
    uint8_t y;

    uint8_t l1;
    uint8_t l2;
    uint8_t r1;
    uint8_t r2;

    uint8_t f1;
    uint8_t f2;
    uint8_t f3;
    uint8_t f4;
    uint8_t f5;
    uint8_t f6;
} network_gamepad_t;


#ifdef __cplusplus
}
#endif