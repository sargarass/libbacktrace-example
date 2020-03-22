include(ExternalProject)

set(liblzma_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/build")
set(liblzma_DIR "${CMAKE_CURRENT_BINARY_DIR}/bin")
set(liblzma_DIR "${liblzma_DIR}" PARENT_SCOPE)

set(liblzma_LIBS ${liblzma_DIR}/lib/liblzma.a)
set(liblzma_LIBS ${liblzma_LIBS} PARENT_SCOPE)

ExternalProject_Add(liblzma_build
DOWNLOAD_COMMAND rsync -a --exclude=.* ${CMAKE_CURRENT_SOURCE_DIR}/ ${liblzma_BUILD_DIR}

PREFIX            ${liblzma_DIR}
SOURCE_DIR        ${liblzma_BUILD_DIR}

CONFIGURE_COMMAND /usr/bin/env ${liblzma_BUILD_DIR}/autogen.sh --with-pic --enable-threads=posix --disable-xz --disable-xzdec --disable-lzmadec --disable-lzmainfo --disable-lzma-links --disable-scripts --disable-doc --enable-static --disable-shared "--prefix=${liblzma_DIR}/" "CFLAGS=-O3 -fPIC"
BINARY_DIR ${liblzma_BUILD_DIR}
BUILD_COMMAND ${SUB_MAKE} ${SUB_MAKE_FLAGS}
BUILD_BYPRODUCTS ${liblzma_LIBS}
INSTALL_DIR ${liblzma_DIR}
INSTALL_COMMAND ${SUB_MAKE} ${SUB_MAKE_FLAGS} install
)

add_library(liblzma INTERFACE)
target_include_directories(liblzma INTERFACE ${liblzma_DIR}/include)
target_link_libraries(liblzma INTERFACE ${liblzma_LIBS})
add_dependencies(liblzma liblzma_build)
