#include <tee_internal_api.h>
#include <tee_internal_api_extensions.h>


#define TA_UUID { 0x01234567, 0x89AB, 0xCDEF, \
                  { 0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF } }


TEE_Result process_image_data(uint8_t *data, size_t size);



TEE_Result TA_CreateEntryPoint(void) {
    return TEE_SUCCESS;
}



void TA_DestroyEntryPoint(void) {
}



TEE_Result TA_OpenSessionEntryPoint(uint32_t param_types,
                                    TEE_Param params[4],
                                    void **session_context) {
    (void)param_types;
    (void)params;
    (void)session_context;
    return TEE_SUCCESS;
}



void TA_CloseSessionEntryPoint(void *session_context) {
    (void)session_context;
}


TEE_Result TA_InvokeCommandEntryPoint(void *session_context,
                                      uint32_t command_id,
                                      uint32_t param_types,
                                      TEE_Param params[4]) {
    (void)session_context;
    (void)param_types;

    switch (command_id) {
        case 0:
            // Command ID for processing image data
            return process_image_data(params[0].memref.buffer, params[0].memref.size);
        default:
            // Unknown command ID
            return TEE_ERROR_BAD_PARAMETERS;
    }
}



TEE_Result process_image_data(uint8_t *data, size_t size) {
    // Perform image processing or other operations securely within the TEE
    TEE_Printf("Received image data size: %zu\n", size);
    TEE_Printf("First few bytes of image data: ");
    for (size_t i = 0; i < size && i < 10; ++i) {
        TEE_Printf("%02X ", data[i]);
    }
    TEE_Printf("\n");

    // image processing logic here

    return TEE_SUCCESS;
}
