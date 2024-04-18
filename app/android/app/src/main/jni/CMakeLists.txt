cmake_minimum_required(VERSION 3.4.1)

add_library(tee_jni SHARED tee_jni.c)

# Include libraries needed for tee_jni lib
target_link_libraries(tee_jni
                      android
                      log)
