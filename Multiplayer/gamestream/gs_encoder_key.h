#pragma once

#ifdef __cplusplus
extern "C" {
#endif


// Random UUID
typedef enum 
{
    GS_ENCODER_KEY_NONE = 0,


    GS_ENCODER_KEY_ASPECT_RATIO = 0xadaa83a7,
    GS_ENCODER_KEY_TITLE = 0xe14c4ddd,


    GS_ENCODER_KEY_MAX = 0xffffffff
} gs_encoder_key_t;


typedef struct 
{
    float aspect_ratio;
} gs_encoder_key_value_fps_t;

typedef struct 
{
    const char* title;
} gs_encoder_key_value_title_t;


#ifdef __cplusplus
}
#endif
