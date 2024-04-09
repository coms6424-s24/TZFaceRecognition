#include <tee_api.h>

#define TA_UUID { 0x12345678, 0x8765, 0x4321, \
                  { 0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde, 0xf0 } }

void entry_point() {
    // Print a message indicating that the TA has been invoked
    printf("Trusted Application invoked\n");
}

TEE_Result TA_CreateEntryPoint(void) {
    // Perform initialization if needed
    return TEE_SUCCESS;
}

void TA_DestroyEntryPoint(void) {
    // Perform cleanup if needed
}

TEE_Result TA_OpenSessionEntryPoint(uint32_t param_types,
                                    TEE_Param params[4],
                                    void **sess_ctx) {
    // Perform any necessary setup for session handling
    return TEE_SUCCESS;
}

void TA_CloseSessionEntryPoint(void *sess_ctx) {
    // Perform cleanup for session handling
}

TEE_Result TA_InvokeCommandEntryPoint(void *sess_ctx,
                                      uint32_t cmd_id,
                                      uint32_t param_types,
                                      TEE_Param params[4]) {
    switch (cmd_id) {
        case 0: // Command ID for invoking the TA
            entry_point();
            return TEE_SUCCESS;
        default:
            return TEE_ERROR_NOT_SUPPORTED;
    }
}
