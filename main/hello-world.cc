#include "lib/hello-time.h"
#include "main/hello-greet.h"
#include <iostream>
#include <string>

int main(int argc, char** argv) {
    std::string who = "world";
    if (argc > 1) {
        who = argv[1];
    }
    std::cout << get_greet(who) << std::endl;
    print_localtime();

    asdf

    // Throw in an unused variable that clang-tidy would complain
    // about if it saw it.
    //
    // This is so we can prove that clang-tidy is getting the
    // proper `copts` command line flags in its compiler database,
    // to match what we set in bazel.
    //
  #if !defined(NO_CLANG_TIDY_TRIPWIRE)
    int i_am_not_used;
  #endif 
    
    return 0;
}
