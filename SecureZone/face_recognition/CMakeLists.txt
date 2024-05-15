cmake_minimum_required(VERSION 3.0)
project(face_recognition)
set(CMAKE_CXX_STANDARD 11)

find_package(OpenCV REQUIRED)

#3work checkpoint why are you hanging brother

set_source_files_properties(src/main.c PROPERTIES LANGUAGE CXX)
set_source_files_properties(test/test_main.c PROPERTIES LANGUAGE CXX)

add_executable(face_recognition src/main.c)
add_executable(face_recognition_test test/test_main.c)

target_link_libraries(face_recognition ${OpenCV_LIBS})
target_link_libraries(face_recognition_test ${OpenCV_LIBS})




file(COPY ${CMAKE_SOURCE_DIR}/test/face_to_store.jpg DESTINATION ${CMAKE_BINARY_DIR}/test)
file(COPY ${CMAKE_SOURCE_DIR}/test/face_to_recognize.jpg DESTINATION ${CMAKE_BINARY_DIR}/test)
file(COPY ${CMAKE_SOURCE_DIR}/src/haarcascade_frontalface_default.xml DESTINATION ${CMAKE_BINARY_DIR}/src)

file(COPY ${CMAKE_SOURCE_DIR}/detected_faces DESTINATION ${CMAKE_BINARY_DIR})
