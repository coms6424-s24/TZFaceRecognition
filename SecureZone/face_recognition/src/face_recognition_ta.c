#include <tee_internal_api.h>
#include <tee_internal_api_extensions.h>
#include <string.h>
#include "face_recognition_ta.h"

static char stored_faces[MAX_FACES][MAX_FACE_SIZE];
static uint32_t num_faces = 0;

TEE_Result TA_CreateEntryPoint(void) {
    return TEE_SUCCESS;
}

void TA_DestroyEntryPoint(void) {}

TEE_Result TA_OpenSessionEntryPoint(uint32_t param_types, TEE_Param params[4], void **sess_ctx) {
    (void)&param_types;
    (void)&params;
    (void)&sess_ctx;
    return TEE_SUCCESS;
}

void TA_CloseSessionEntryPoint(void *sess_ctx) {
    (void)&sess_ctx;
}

static TEE_Result store_face(uint32_t param_types, TEE_Param params[4]) {
    uint32_t exp_param_types = TEE_PARAM_TYPES(TEE_PARAM_TYPE_MEMREF_INPUT,
                                               TEE_PARAM_TYPE_NONE,
                                               TEE_PARAM_TYPE_NONE,
                                               TEE_PARAM_TYPE_NONE);

    if (param_types != exp_param_types) {
        return TEE_ERROR_BAD_PARAMETERS;
    }

    if (num_faces >= MAX_FACES) {
        return TEE_ERROR_OVERFLOW;
    }

    const char *face_data = (const char *)params[0].memref.buffer;
    size_t face_len = params[0].memref.size;

    if (face_len > MAX_FACE_SIZE) {
        return TEE_ERROR_BAD_PARAMETERS;
    }

    TEE_MemMove(stored_faces[num_faces], face_data, face_len);
    num_faces++;

    return TEE_SUCCESS;
}

static TEE_Result recognize_face(uint32_t param_types, TEE_Param params[4]) {
    uint32_t exp_param_types = TEE_PARAM_TYPES(TEE_PARAM_TYPE_MEMREF_INPUT,
                                               TEE_PARAM_TYPE_VALUE_OUTPUT,
                                               TEE_PARAM_TYPE_NONE,
                                               TEE_PARAM_TYPE_NONE);

    if (param_types != exp_param_types) {
        return TEE_ERROR_BAD_PARAMETERS;
    }

    const char *face_data = (const char *)params[0].memref.buffer;
    size_t face_len = params[0].memref.size;

    if (face_len > MAX_FACE_SIZE) {
        return TEE_ERROR_BAD_PARAMETERS;
    }

    for (uint32_t i = 0; i < num_faces; i++) {
        if (TEE_MemCompare(stored_faces[i], face_data, face_len) == 0) {
            params[1].value.a = 1; // Match
            return TEE_SUCCESS;
        }
    }

    params[1].value.a = 0; // No match
    return TEE_SUCCESS;
}

static TEE_Result delete_face(uint32_t param_types, TEE_Param params[4]) {
    uint32_t exp_param_types = TEE_PARAM_TYPES(TEE_PARAM_TYPE_NONE,
                                               TEE_PARAM_TYPE_NONE,
                                               TEE_PARAM_TYPE_NONE,
                                               TEE_PARAM_TYPE_NONE);

    if (param_types != exp_param_types) {
        return TEE_ERROR_BAD_PARAMETERS;
    }

    if (num_faces == 0) {
        return TEE_ERROR_ITEM_NOT_FOUND;
    }

    num_faces--;
    TEE_MemMove(stored_faces[num_faces], "", 1); // Clear the last entry

    return TEE_SUCCESS;
}

TEE_Result TA_InvokeCommandEntryPoint(void *sess_ctx, uint32_t cmd_id,
                                      uint32_t param_types, TEE_Param params[4]) {
    (void)&sess_ctx;

    switch (cmd_id) {
        case CMD_STORE_FACE:
            return store_face(param_types, params);
        case CMD_RECOGNIZE_FACE:
            return recognize_face(param_types, params);
        case CMD_DELETE_FACE:
            return delete_face(param_types, params);
        default:
            return TEE_ERROR_NOT_SUPPORTED;
    }
}
