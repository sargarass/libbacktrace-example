include(ExternalProject)

set(LIBBACKTRACE_BUILD_DIR "${PROJECT_BINARY_DIR}/libbacktrace/build")
set(LIBBACKTRACE_DIR "${PROJECT_BINARY_DIR}/libbacktrace/bin")

set(LIBBACKTRACE_LIBS
        ${LIBBACKTRACE_DIR}/lib/libbacktrace.a)
        
ExternalProject_Add(libbacktrace_build
        DOWNLOAD_COMMAND rsync -a --exclude=.* ${PROJECT_SOURCE_DIR}/libbacktrace/ ${LIBBACKTRACE_BUILD_DIR}

        PREFIX ${LIBBACKTRACE_DIR}
        SOURCE_DIR ${LIBBACKTRACE_BUILD_DIR}
        
        CONFIGURE_COMMAND ./configure --prefix "${LIBBACKTRACE_DIR}" --with-pic --enable-static --disable-shared --enable-minidebuginfo "CFLAGS=-O3 -fPIC -I\"${liblzma_DIR}/include\"" "LDFLAGS=-L${liblzma_DIR}/lib/"
        BINARY_DIR ${LIBBACKTRACE_BUILD_DIR}
        BUILD_COMMAND ${SUB_MAKE} ${SUB_MAKE_FLAGS}
        BUILD_BYPRODUCTS ${LIBBACKTRACE_LIBS}
        INSTALL_DIR ${LIBBACKTRACE_DIR}
        INSTALL_COMMAND ${SUB_MAKE} ${SUB_MAKE_FLAGS} install
        DEPENDS liblzma
) 

add_library(libbacktrace INTERFACE)
target_include_directories(libbacktrace INTERFACE "${LIBBACKTRACE_DIR}/include")
target_link_libraries(libbacktrace INTERFACE ${LIBBACKTRACE_LIBS} liblzma)
add_dependencies(libbacktrace libbacktrace_build)
