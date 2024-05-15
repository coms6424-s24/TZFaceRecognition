cmake_minimum_required(VERSION 3.0)
project(face_recognition)
set(CMAKE_CXX_STANDARD 11)

find_package(OpenCV REQUIRED)

set_source_files_properties(src/main.c PROPERTIES LANGUAGE CXX)

add_executable(face_recognition src/main.c)

target_link_libraries(face_recognition ${OpenCV_LIBS})

#Not working idk why
file(COPY ${CMAKE_SOURCE_DIR}/test/face_to_store.jpg DESTINATION ${CMAKE_BINARY_DIR}/test)
file(COPY ${CMAKE_SOURCE_DIR}/test/face_to_recognize.jpg DESTINATION ${CMAKE_BINARY_DIR}/test)
file(COPY ${CMAKE_SOURCE_DIR}/src/haarcascade_frontalface_default.xml DESTINATION ${CMAKE_BINARY_DIR}/src)

# Copy the folder containing the detected faces to the build directory
file(COPY ${CMAKE_SOURCE_DIR}/detected_faces DESTINATION ${CMAKE_BINARY_DIR})
