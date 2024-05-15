#include <stdio.h>
#include <string.h>
#include <tee_client_api.h>
#include "face_recognition_ta.h"
#include <opencv2/opencv.hpp>

using namespace cv;

void store_face(TEEC_Context *ctx, TEEC_Session *sess, const Mat &face_image) {
    TEEC_Operation op;
    TEEC_Result res;
    std::vector<uchar> buf;
    imencode(".jpg", face_image, buf);

    memset(&op, 0, sizeof(op));
    op.paramTypes = TEEC_PARAM_TYPES(TEEC_MEMREF_TEMP_INPUT, TEEC_NONE, TEEC_NONE, TEEC_NONE);
    op.params[0].tmpref.buffer = buf.data();
    op.params[0].tmpref.size = buf.size();

    res = TEEC_InvokeCommand(sess, CMD_STORE_FACE, &op, NULL);
    if (res != TEEC_SUCCESS) {
        printf("Failed to store face: 0x%x\n", res);
    }
}

int recognize_face(TEEC_Context *ctx, TEEC_Session *sess, const Mat &face_image) {
    TEEC_Operation op;
    TEEC_Result res;
    uint32_t err_origin;
    std::vector<uchar> buf;
    imencode(".jpg", face_image, buf);

    memset(&op, 0, sizeof(op));
    op.paramTypes = TEEC_PARAM_TYPES(TEEC_MEMREF_TEMP_INPUT, TEEC_PARAM_TYPE_VALUE_OUTPUT, TEEC_NONE, TEEC_NONE);
    op.params[0].tmpref.buffer = buf.data();
    op.params[0].tmpref.size = buf.size();

    res = TEEC_InvokeCommand(sess, CMD_RECOGNIZE_FACE, &op, &err_origin);
    if (res != TEEC_SUCCESS) {
        printf("Failed to recognize face: 0x%x (err_origin: 0x%x)\n", res, err_origin);
        return -1;
    }

    return op.params[1].value.a;
}

void delete_last_face(TEEC_Context *ctx, TEEC_Session *sess) {
    TEEC_Operation op;
    TEEC_Result res;

    memset(&op, 0, sizeof(op));
    op.paramTypes = TEEC_PARAM_TYPES(TEEC_NONE, TEEC_NONE, TEEC_NONE, TEEC_NONE);

    res = TEEC_InvokeCommand(sess, CMD_DELETE_FACE, &op, NULL);
    if (res != TEEC_SUCCESS) {
        printf("Failed to delete face: 0x%x\n", res);
    }
}

int main() {
    TEEC_Context ctx;
    TEEC_Session sess;
    TEEC_UUID uuid = TA_FACE_RECOGNITION_UUID;
    TEEC_Result res;
    uint32_t err_origin;

    res = TEEC_InitializeContext(NULL, &ctx);
    if (res != TEEC_SUCCESS) {
        printf("TEEC_InitializeContext failed: 0x%x\n", res);
        return 1;
    }

    res = TEEC_OpenSession(&ctx, &sess, &uuid, TEEC_LOGIN_PUBLIC, NULL, NULL, &err_origin);
    if (res != TEEC_SUCCESS) {
        printf("TEEC_OpenSession failed: 0x%x\n", res);
        TEEC_FinalizeContext(&ctx);
        return 1;
    }

    Mat face_image = imread("face_to_store.jpg", IMREAD_GRAYSCALE);
    if (face_image.empty()) {
        printf("Failed to load face image\n");
        return 1;
    }
    store_face(&ctx, &sess, face_image);

    Mat new_face_image = imread("face_to_recognize.jpg", IMREAD_GRAYSCALE);
    if (new_face_image.empty()) {
        printf("Failed to load new face image\n");
        return 1;
    }
    int match = recognize_face(&ctx, &sess, new_face_image);
    if (match) {
        printf("Face recognized\n");
    } else {
        printf("Face not recognized\n");
    }

    delete_last_face(&ctx, &sess);

    TEEC_CloseSession(&sess);
    TEEC_FinalizeContext(&ctx);

    return 0;
}
