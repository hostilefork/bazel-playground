> This fork of the bazel-test was hacked up mildly at one time to support use
> with Clang-Tidy, and was aiming to be used with AVR toolchains...that project
> was discontinued some time ago.  But in the interest of not throwing it away
> in case it ever has any value, the tweaks are pushed to GitHub and set to
> archival status.

# C Bazel Example: Library, Executable, and Google Gtest

**TL;DR:**

    bazel build //main:hello-world
    bazel test //test:hello-test

### Include multiple targets and deps

In this stage we step it up and showcase how to integrate multiple ```cc_library``` targets from different packages.

Below, we see a similar configuration from Stage 2, except that this BUILD.bazel file is in a subdirectory called lib. In Bazel, subdirectories containing BUILD.bazel files are known as packages. The new property ```visibility``` will tell Bazel which package(s) can reference this target, in this case the ```//main``` package can use ```hello-time``` library.

    cc_library(
        name = "hello-time",
        srcs = ["hello-time.cc"],
        hdrs = ["hello-time.h"],
        visibility = ["//main:__pkg__"],
    )

To use our ```hello-time``` libary, an extra dependency is added in the form of //path/to/package:target_name, in this case, it's ```//lib:hello-time```

    cc_binary(
        name = "hello-world",
        srcs = ["hello-world.cc"],
        deps = [
            ":hello-greet",
            "//lib:hello-time",
        ],
    )

To build this example you use (notice that 3 slashes are required in windows)

    bazel build //main:hello-world

In Windows, note the three slashes

    bazel build ///main:hello-world

This example is referred from [bazel document](https://docs.bazel.build/versions/master/tutorial/cpp.html)

### External dependency and gtest example

In this step we will see how to include external dependency, for example `gtest`.

Let's write a test `test/hello-test.cc` for testing `get_greet()` function.

    #include "gtest/gtest.h"
    #include "main/hello-greet.h"

    TEST(HelloTest, GetGreet) {
        EXPECT_EQ(get_greet("Bazel"), "Hello Bazel");
    }

Now lets create `test/BUILD.bazel`

    cc_test(
        name = "hello-test",
        srcs = ["hello-test.cc"],
        deps = [
            "@gtest//:gtest",  # need for #include "gtest/gtest.h"
            "@gtest//:gtest-main",  # need because hello-test has no main()
            "//main:hello-greet",  # need for #include "main/hello-greet.h"
        ]
    )

These reference @gtest, but where does it come from?  It has to be put into the workspace.

At one time, Google's gtest did not have a BUILD.bazel file.  But now it does, so there is no need to define a custom `build_file` for the source archive.

In `WORKSPACE` specify external repository to use in this project:

    load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

    git_repository(
        name = "gtest",
        remote = "https://github.com/google/googletest",
        branch = "v1.10.x",
    )

Now, run:

    bazel test //test:hello-test

Yaay!!


### Support for Static Analysis, Linting, Guidelines... 

Clang-Tidy is an interface to the "Clang Powertools".  It not only does C and C++ linting, but it also has support for Clang Static Analyzer and many cool features: 

https://www.clangpowertools.com/QaA.html
https://clang.llvm.org/extra/clang-tidy/
https://clang.llvm.org/extra/clang-tidy/checks/list.html

The following MIT-Licensed Bazel code is incorporated into this project in the `clang-tidy/` directory:

https://github.com/erenon/bazel_clang_tidy

In order to invoke it, use:

> `bazel build //main:hello-world --aspects clang_tidy/clang_tidy.bzl%clang_tidy_aspect --output_groups=report`

Global settings for what warnings the tool should enable or ignore are in the `/.clang-tidy` file.  See notes in that file.
