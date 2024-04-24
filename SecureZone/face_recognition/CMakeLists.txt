cmake_minimum_required(VERSION 3.0)
project(face_recognition)
set(CMAKE_CXX_STANDARD 11)

find_package(OpenCV REQUIRED)

# Ensure OpenCV headers are treated as C++ files
set_source_files_properties(src/main.c PROPERTIES LANGUAGE CXX)

add_executable(face_recognition src/main.c)
target_link_libraries(face_recognition ${OpenCV_LIBS})
