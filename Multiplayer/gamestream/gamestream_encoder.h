#pragma once

#include <network_gamepad.h>
#include <gs_encoder_key.h>

#include <stdint.h>

#include <go2/display.h>


#ifdef __cplusplus
extern "C" {
#endif


#define GAMESTREAM_ENCODER_PLAYER_INDEX_MAX (1)


typedef struct gs_encoder_session gs_encoder_session_t;

gs_encoder_session_t* gs_encoder_session_create(int width, int height, int fps, int sample_rate);
void gs_encoder_session_destroy(gs_encoder_session_t* session);

int gs_encoder_session_value_set(gs_encoder_session_t* session, gs_encoder_key_t key, uint8_t value[1024]);

//int gs_encoder_session_client_count_get(gs_encoder_session_t* session);

int gs_encoder_session_audio_post(gs_encoder_session_t* session, int16_t* samples, int frameCount);
int gs_encoder_session_video_post(gs_encoder_session_t* session, go2_surface_t* surface, int srcX, int srcY, int srcWidth, int srcHeight);

int gs_encoder_session_gamepad_read(gs_encoder_session_t* session, int player_index, network_gamepad_t* out_gamepad_state);


int gs_network_client_count_get(gs_encoder_session_t* session);


#ifdef __cplusplus
}
#endif
