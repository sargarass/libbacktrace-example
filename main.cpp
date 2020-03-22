#include <iostream>
#include <boost/stacktrace.hpp>
#include <boost/exception/all.hpp>
#include <cxxabi.h>

using traced = boost::error_info<struct tag_stacktrace, boost::stacktrace::stacktrace>;

template<class E>
void throw_with_trace(const E &e) {
    throw boost::enable_error_info(e) << traced(boost::stacktrace::stacktrace(1, -1));
}

inline std::string cxxDemangle(char const *mangled)
{
    int status;
    char *ret = abi::__cxa_demangle(mangled, nullptr, nullptr, &status);
    switch (status) {
        case 0: break;
        case -1: throw std::bad_alloc();
        case -2: throw std::logic_error("Not a proper mangled name" + std::string(mangled));
        case -3: throw std::invalid_argument("Invalid argument to __cxa_demangle");
        default: throw std::logic_error("Unknown error from __cxa_demangle");
    }
    std::string name(ret);
    free(ret);
    return name;
}

void f() {
    throw_with_trace(std::runtime_error("test exception"));
}

int main(int argv, char **argc) {
    try {
        f();
    } catch (std::exception const &e) {
        const boost::stacktrace::stacktrace* st = boost::get_error_info<traced>(e);
        std::cerr << "Got exception with type " << cxxDemangle(typeid(e).name()) << ": " <<  e.what() << std::endl;
        if (st) {
            std::cerr << *st << std::endl;
        }
    }
    return 0;
}
