project(libbacktrace-example)
include(ExternalProject)

cmake_minimum_required(VERSION 3.2)
set(SUB_MAKE "make" CACHE FILEPATH "Make binary (for Makefile-based subprojects)")
set(SUB_MAKE_FLAGS "-j${CPU_COUNT}" CACHE STRING "Make arguments (for Makefile-based subprojects; semicolon-separated)")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin)
add_compile_options(-g1 -O3)

add_subdirectory(liblzma)
include(libbacktrace.cmake)
add_subdirectory(small_boost)

add_executable(test_app main.cpp)
target_link_libraries(test_app PRIVATE boost)

add_custom_command(TARGET test_app
                   POST_BUILD
                   COMMAND objcopy --only-keep-debug "$<TARGET_FILE:test_app>" "$<TARGET_FILE:test_app>.debug"
                   COMMAND strip --strip-debug "$<TARGET_FILE:test_app>"
                   COMMAND xz -f "$<TARGET_FILE:test_app>.debug"
                   COMMAND objcopy --add-section .gnu_debugdata="$<TARGET_FILE:test_app>.debug.xz" "$<TARGET_FILE:test_app>"
                   COMMAND rm -rf "$<TARGET_FILE:test_app>.debug.xz"
                   )
