## Current state

The state of cpp4r is pretty stable, it seems to have the features we need for most of our projects using C++.

## Known outstanding issues

### Running the cpp4rtest tests

Most of the test suite is in a sub-package, cpp4rtest.
The best way to run these tests is to install the development version of cpp4r after any change, and then run `devtools::test("./cpp4rtest")`.
Precisely, this looks like:

```r
# Install dev cpp4r, clean the cpp4rtest dll manually since it thinks nothing
# has changed, then recompile and run its tests.
devtools::install()
devtools::clean_dll("./cpp4rtest")
devtools::test("./cpp4rtest")
```

If tests failures occur the output from Catch isn't always easy to interpret.
I have a branch of testthat https://github.com/jimhester/testthat/tree/catch-detailed-output that should make things easier to understand.
I contributed those changes to the main testthat, but something changed after merging the more detailed output was lost, I unfortunately never had the time to track down the cause and fix it.

In addition getting a debugger to catch when errors happen can be fiddly when running the cpp4rtest tests, something about the way that Catch redirects stderr / stdout interacts with the debugger.

The GitHub Actions workflow has some additional logic to handle running the cpp4r tests https://github.com/r-lib/cpp4r/blob/fd8ef97d006db847f7f17166cf52e1e0383b2d35/.github/workflows/R-CMD-check.yaml#L95-L102, https://github.com/r-lib/cpp4r/blob/fd8ef97d006db847f7f17166cf52e1e0383b2d35/.github/workflows/R-CMD-check.yaml#L117-L124.

## Ensure you use `Sys.setenv("cpp4r_EVAL" = "true"); devtools::submit_cran()` when submitting.

If you forget to set `CPP_EVAL = "true"` then the vignette chunks will not run properly and the vignettes will not be rendered properly.

## Regenerating benchmark objects used in `motivations.Rmd`

If you need to regenerate the benchmark objects (RDS objects) utilized in `motivations.Rmd`, then you should set `Sys.setenv("cpp4rTEST_SHOULD_RUN_BENCHMARKS" = "TRUE")` before running the Rmd. You'll also need to make sure that cpp4rtest is actually installed. See `cpp4rtest:::should_run_benchmarks()` for more.

## Usage with clangd

Since cpp4r is header only, if you use clangd you'll have a bit of an issue because tools like bear and pkgload won't know how to generate the `compile_commands.json` file. Instead, you can create it manually with something like this, which seems to work well. Note that the paths are specific to your computer.

```
[
    {
        "command": "g++ -std=gnu++11 -I\"/Users/davis/files/r/packages/cpp4r/inst/include\" -I\"/Library/Frameworks/R.framework/Resources/include\" -I\"/Users/davis/Library/R/arm64/4.4/library/Rcpp/include\" -I\"/Users/davis/Library/R/arm64/4.4/library/testthat/include\" -I\"/opt/homebrew/include\" -Wall -pedantic",
        "file": "R.hpp",
        "directory": "/Users/davis/files/r/packages/cpp4r/inst/include/cpp4r"
    }
]
```

Key notes:

- Only doing this for `R.hpp` seems to be enough. I imagine this could be any of the header files, but it is reasonable to pick the "root" one that pretty much all others include.
- Using `-std=gnu++11` to keep us honest about only C++11 features.
- Using `-I\"/Library/Frameworks/R.framework/Resources/include\"` for access to the R headers.
- Using `-I\"/Users/davis/files/r/packages/cpp4r/inst/include\"` as a "self include", which seems to be the key to the whole thing.

If you are modifying any tests or benchmarks, you also need:

- `-I\"/Users/davis/Library/R/arm64/4.4/library/Rcpp/include\"` for Rcpp headers.
- `-I\"/Users/davis/Library/R/arm64/4.4/library/testthat/include\"` for testthat headers related to Catch tests.

Note that this is specific to a path on your machine and the R version you are currently working with.

## Future directions

Some work could be spent in smoothing out the `cpp_source()` / knitr chunk experience.
Our main focus and use cases were in R packages, so that usage is more tested.
Because we don't typically use cpp4r in non package contexts those use cases may not be as nice.

For similar reasons the matrix support might be somewhat lacking, as the majority of our use cases do not deal with numeric matrices.
