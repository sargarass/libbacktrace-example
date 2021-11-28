# libbacktrace-example
MiniDebuginfo is GDB's feature that allows to greatly reduce executable binary size while preserving debug information needed for debugger. Basically, minidebuginfo means that debug sections were xz-compressed. In order to use them again decompression must be performed. Patch in the repository https://github.com/sargarass/libbacktrace adds such support to libbacktrace which could be used in your codebase to get backtrace with code line/file information. For example, this library is used as backend for boost stacktrace and as part of the gcc.

# Dependancies:
1. Cmake >= 3.0
2. nothing else?

# How to build
1. clone the repo and initialize submodules (libbacktrace).
2. create "build" directory in a cloned directory.
3. cd build && cmake ..
4. make

# How to run
build/bin/test_app

# What will I see?
Something like this in a console:
```
Got exception with type boost::exception_detail::error_info_injector<std::runtime_error>: test exception
 0# f() at /home/sargarass/Github/libbacktrace-example/main.cpp:30
 1# main at /home/sargarass/Github/libbacktrace-example/main.cpp:35
 2# __libc_start_main in /lib64/libc.so.6
 3# _start in ./test_app
```

Also u can check sections that test_app has (readelf -S test_app).
There is no "debug" section because it was packed into .gnu_debugdata in lzma compressed format while target was building:
```
add_custom_command(TARGET test_app
                   POST_BUILD
                   COMMAND objcopy --only-keep-debug "$<TARGET_FILE:test_app>" "$<TARGET_FILE:test_app>.debug"
                   COMMAND strip --strip-debug "$<TARGET_FILE:test_app>"
                   COMMAND xz -f "$<TARGET_FILE:test_app>.debug"
                   COMMAND objcopy --add-section .gnu_debugdata="$<TARGET_FILE:test_app>.debug.xz" "$<TARGET_FILE:test_app>"
                   COMMAND rm -rf "$<TARGET_FILE:test_app>.debug.xz"
)
```

