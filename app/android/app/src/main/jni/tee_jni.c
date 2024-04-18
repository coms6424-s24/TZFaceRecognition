#include <jni.h>

JNIEXPORT void JNICALL
Java_com_example_app_MainActivity_sendDataToTEE(JNIEnv *env, jobject thiz, jbyteArray data) {
    // Convert Java byte array to native C array
    jbyte *nativeData = (*env)->GetByteArrayElements(env, data, NULL);
    jsize size = (*env)->GetArrayLength(env, data);

    // Call TEE function with the data
    // Replace this with your actual TEE communication code
    // For demonstration purposes, we'll print the data
    printf("Sending data to TEE:\n");
    for (int i = 0; i < size; i++) {
        printf("%02X ", (unsigned char) nativeData[i]);
    }
    printf("\n");

    // Release native array
    (*env)->ReleaseByteArrayElements(env, data, nativeData, 0);
}
