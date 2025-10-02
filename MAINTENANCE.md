## Current state

The state of cpp4r is pretty stable.

## Known outstanding issues

### Running the cpp4rtest tests

Most of the test suite is in a sub-package, cpp4rtest. This is because we need to test compiled code. The best way to run these tests is to install the development version of cpp4r after any change, and then run:

```bash
make test
```

## Set the environment variables when submitting

If you forget to set `CPP4R_EVAL = "true"` then the vignette chunks will not run properly and the vignettes will not be rendered properly.

Run this:

```r
Sys.setenv("CPP4R_EVAL" = "true"); devtools::submit_cran()
```

## Regenerating benchmark objects used in `motivations.Rmd`

If you need to regenerate the benchmark objects (RDS objects) utilized in `motivations.Rmd`, then you should set `Sys.setenv("CPP4R_RUN_BENCHMARKS" = "true")` before running the Rmd. You'll also need to make sure that cpp4rtest is actually installed.

## Usage with clangd

Since cpp4r is header only, if you use clangd you'll have a bit of an issue because tools like bear and pkgload won't know how to generate the `compile_commands.json` file. Instead, you can create it manually with something like this, which seems to work well. Note that the paths are specific to your computer.

```
[
    {
        "command": "g++ -std=gnu++11 -I\"/home/pacha/files/r/packages/cpp4r/inst/include\" -I\"/Library/Frameworks/R.framework/Resources/include\" -I\"/home/pacha/Library/R/x64/4.4/library/Rcpp/include\" -I\"/home/pacha/Library/R/x64/4.4/library/testthat/include\" -I\"/opt/homebrew/include\" -Wall -pedantic",
        "file": "R.hpp",
        "directory": "/home/pacha/files/r/packages/cpp4r/inst/include/cpp4r"
    }
]
```

Key notes:

- Only doing this for `R.hpp` seems to be enough. I imagine this could be any of the header files, but it is reasonable to pick the "root" one that pretty much all others include.
- Using `-std=gnu++11` to keep us honest about only C++11 features.
- Using `-I\"/Library/Frameworks/R.framework/Resources/include\"` for access to the R headers.
- Using `-I\"/home/pacha/files/r/packages/cpp4r/inst/include\"` as a "self include", which seems to be the key to the whole thing.

If you are modifying any tests or benchmarks, you also need:

- `-I\"/home/pacha/Library/R/x64/4.4/library/Rcpp/include\"` for Rcpp headers.
- `-I\"/home/pacha/Library/R/x64/4.4/library/testthat/include\"` for testthat headers related to Catch tests.

Note that this is specific to a path on your machine and the R version you are currently working with.

## Future directions

Some work could be spent in smoothing out the `cpp_source()` / knitr chunk experience.
Our main focus and use cases were in R packages, so that usage is more tested.
Because we don't typically use cpp4r in non package contexts those use cases may not be as nice.

For similar reasons the matrix support might be somewhat lacking, as the majority of our use cases do not deal with numeric matrices.
