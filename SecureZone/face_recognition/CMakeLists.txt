cmake_minimum_required(VERSION 3.0)
project(face_recognition)

find_package(OpenCV REQUIRED)

add_executable(face_recognition src/main.c)
target_link_libraries(face_recognition ${OpenCV_LIBS})
