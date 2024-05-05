#include <err.h>
#include <stdio.h>
#include <string.h>

#include <tee_client_api.h>
#include <secure_storage_ta.h>

#include <dlib/image_processing/frontal_face_detector.h>
#include <dlib/image_processing.h>
#include <dlib/image_io.h>

#define LOGIN_FLAG true
#define AUTH_OK false

struct test_ctx {
    TEEC_Context ctx;
    TEEC_Session sess;
};

void prepare_tee_session(struct test_ctx *ctx)
{
    TEEC_UUID uuid = TA_READ_FILE_UUID;
    uint32_t origin;
    TEEC_Result res;

    res = TEEC_InitializeContext(NULL, &ctx->ctx);
    if (res != TEEC_SUCCESS)
        errx(1, "TEEC_InitializeContext failed with code 0x%x", res);

    res = TEEC_OpenSession(&ctx->ctx, &ctx->sess, &uuid,
                           TEEC_LOGIN_PUBLIC, NULL, NULL, &origin);
    if (res != TEEC_SUCCESS)
        errx(1, "TEEC_Opensession failed with code 0x%x origin 0x%x", res, origin);
}

void terminate_tee_session(struct test_ctx *ctx)
{
    TEEC_CloseSession(&ctx->sess);
    TEEC_FinalizeContext(&ctx->ctx);
}

TEEC_Result read_secure_object(struct test_ctx *ctx, char *id,
                               char *data, size_t data_len)
{
    TEEC_Operation op;
    uint32_t origin;
    TEEC_Result res;
    size_t id_len = strlen(id);

    memset(&op, 0, sizeof(op));
    op.paramTypes = TEEC_PARAM_TYPES(TEEC_MEMREF_TEMP_INPUT,
                                     TEEC_MEMREF_TEMP_OUTPUT,
                                     TEEC_NONE, TEEC_NONE);

    op.params[0].tmpref.buffer = id;
    op.params[0].tmpref.size = id_len;

    op.params[1].tmpref.buffer = data;
    op.params[1].tmpref.size = data_len;

    res = TEEC_InvokeCommand(&ctx->sess,
                             TA_SECURE_STORAGE_CMD_READ_RAW,
                             &op, &origin);
    switch (res) {
        case TEEC_SUCCESS:
        case TEEC_ERROR_SHORT_BUFFER:
        case TEEC_ERROR_ITEM_NOT_FOUND:
            break;
        default:
            printf("Command READ_RAW failed: 0x%x / %u\n", res, origin);
    }

    return res;
}

TEEC_Result write_secure_object(struct test_ctx *ctx, char *id,
                                char *data, size_t data_len)
{
    TEEC_Operation op;
    uint32_t origin;
    TEEC_Result res;
    size_t id_len = strlen(id);

    memset(&op, 0, sizeof(op));
    op.paramTypes = TEEC_PARAM_TYPES(TEEC_MEMREF_TEMP_INPUT,
                                     TEEC_MEMREF_TEMP_INPUT,
                                     TEEC_NONE, TEEC_NONE);

    op.params[0].tmpref.buffer = id;
    op.params[0].tmpref.size = id_len;

    op.params[1].tmpref.buffer = data;
    op.params[1].tmpref.size = data_len;

    res = TEEC_InvokeCommand(&ctx->sess,
                             TA_SECURE_STORAGE_CMD_WRITE_RAW,
                             &op, &origin);
    if (res != TEEC_SUCCESS)
        printf("Command WRITE_RAW failed: 0x%x / %u\n", res, origin);

    switch (res) {
        case TEEC_SUCCESS:
            break;
        default:
            printf("Command WRITE_RAW failed: 0x%x / %u\n", res, origin);
    }

    return res;
}

TEEC_Result delete_secure_object(struct test_ctx *ctx, char *id)
{
    TEEC_Operation op;
    uint32_t origin;
    TEEC_Result res;
    size_t id_len = strlen(id);

    memset(&op, 0, sizeof(op));
    op.paramTypes = TEEC_PARAM_TYPES(TEEC_MEMREF_TEMP_INPUT,
                                     TEEC_NONE, TEEC_NONE, TEEC_NONE);

    op.params[0].tmpref.buffer = id;
    op.params[0].tmpref.size = id_len;

    res = TEEC_InvokeCommand(&ctx->sess,
                             TA_SECURE_STORAGE_CMD_DELETE,
                             &op, &origin);

    switch (res) {
        case TEEC_SUCCESS:
        case TEEC_ERROR_ITEM_NOT_FOUND:
            break;
        default:
            printf("Command DELETE failed: 0x%x / %u\n", res, origin);
    }

    return res;
}

#define TEST_OBJECT_SIZE    7000
#define MAX_HASH_LENGTH     7000

#define FACE_RECOGNITION_MODEL "shape_predictor_68_face_landmarks.dat"

TEEC_Result authentication(struct test_ctx *ctx, char *id)
{
    if (LOGIN_FLAG == true) {
        // Load face detector and shape predictor
        dlib::frontal_face_detector detector = dlib::get_frontal_face_detector();
        dlib::shape_predictor sp;
        dlib::deserialize(FACE_RECOGNITION_MODEL) >> sp;

        // Capture image and process
        dlib::array2d<dlib::bgr_pixel> img;
        // Load image from camera or file
        // dlib::load_image(img, "path_to_image.jpg");

        // Detect faces
        std::vector<dlib::rectangle> dets = detector(img);

        // Iterate through faces
        for (size_t i = 0; i < dets.size(); ++i) {
            dlib::full_object_detection shape = sp(img, dets[i]);
            // Perform face recognition using shape landmarks
            // Compare with stored facial features
            // If match found, return AUTH_OK
        }
        
        // No face found or recognition failed, return error
        return TEEC_ERROR_ACCESS_DENIED;
    } else {
        // Store facial features in secure storage
        // Implementation left for you
        return TEEC_SUCCESS;
    }
}

int main(void)
{
    struct test_ctx ctx;
    char user_id[] = "user#1";
    TEEC_Result res;

    printf("Prepare session with the TA\n");
    prepare_tee_session(&ctx);

    // Perform authentication
    res = authentication(&ctx, user_id);
    if (res == AUTH_OK) {
        printf("Authentication successful!\n");
    } else {
        printf("Authentication failed!\n");
    }

    printf("\nWe're done, close and release TEE resources\n");
    terminate_tee_session(&ctx);
    return 0;
}
