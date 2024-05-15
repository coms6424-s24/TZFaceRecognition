#include <stdio.h>
#include <string.h>
#include <opencv2/opencv.hpp>
#include <tee_client_api.h>
#include "face_recognition_ta.h"

using namespace cv;
//func declations 
Mat read_image_from_buffer(const std::vector<uchar>& buffer);
void store_face(TEEC_Context *ctx, TEEC_Session *sess, const Mat &face_image);
int recognize_face(TEEC_Context *ctx, TEEC_Session *sess, const Mat &face_image);
void delete_last_face(TEEC_Context *ctx, TEEC_Session *sess);

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

    Mat face_image = imread("test/face_to_store.jpg", IMREAD_GRAYSCALE);
    if (face_image.empty()) {
        printf("Failed to load face image from file\n");
        return 1;
    }
    store_face(&ctx, &sess, face_image);

    Mat new_face_image = imread("test/face_to_recognize.jpg", IMREAD_GRAYSCALE);
    if (new_face_image.empty()) {
        printf("Failed to load new face image from file\n");
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
