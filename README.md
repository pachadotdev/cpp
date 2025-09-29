# cpp4r

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/r-lib/cpp4r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-lib/cpp4r/actions/workflows/R-CMD-check.yaml)
[![CRAN status](https://www.r-pkg.org/badges/version/cpp4r)](https://CRAN.R-project.org/package=cpp4r)
[![Codecov test coverage](https://codecov.io/gh/r-lib/cpp4r/branch/main/graph/badge.svg)](https://app.codecov.io/gh/r-lib/cpp4r?branch=main)
<!-- badges: end -->

cpp4r helps you to interact with R objects using C++ code.
Its goals and syntax are similar to the excellent [Rcpp](https://cran.r-project.org/package=Rcpp) package.

## Using cpp4r in a package

To add cpp4r to an existing package, put your C++ files in the `src/` directory and add the following to your DESCRIPTION file:

```
LinkingTo: cpp4r
```

Then decorate C++ functions you want to expose to R with `[[cpp4r::register]]`.
*Note that this is a [C++11 attribute](https://en.cppreference.com/w/cpp/language/attributes), not a comment like is used in Rcpp.*

cpp4r is a header only library with no hard dependencies and does not use a shared library, so it is straightforward and reliable to use in packages without fear of compile-time and run-time mismatches.

Alternatively, you can [vendor](https://cpp4r.r-lib.org/articles/motivations.html#vendoring) the current installed version of cpp4r headers into your package with `cpp4r::vendor_cpp4r()`.
This ensures the headers will remain unchanged until you explicitly update them.

## Getting started

See [vignette("cpp4r")](https://cpp4r.r-lib.org/articles/cpp4r.html) to get started using cpp4r in your scripts, particularly if you are new to C++ programming.

## Getting help

[Posit Community](https://forum.posit.co/) is the best place to ask for help using cpp4r or interfacing C++ with R.

## Motivations

[Rcpp](https://cran.r-project.org/package=Rcpp) has been a widely successful project, however over the years a number of issues and additional C++ features have arisen.
Adding these features to Rcpp would require a great deal of work, or in some cases would be impossible without severely breaking backwards compatibility.

**cpp4r** is a ground up rewrite of C++ bindings to R with different design trade-offs and features.

Changes that motivated cpp4r include:

- Enforcing [copy-on-write semantics](https://cpp4r.r-lib.org/articles/motivations.html#copy-on-write-semantics).
- Improving the [safety](https://cpp4r.r-lib.org/articles/motivations.html#improve-safety) of using the R API from C++ code.
- Supporting [ALTREP objects](https://cpp4r.r-lib.org/articles/motivations.html#altrep-support).
- Using [UTF-8 strings](https://cpp4r.r-lib.org/articles/motivations.html#utf-8-everywhere) everywhere.
- Applying newer [C++11 features](https://cpp4r.r-lib.org/articles/motivations.html#c11-features).
- Having a more straightforward, [simpler implementation](https://cpp4r.r-lib.org/articles/motivations.html#simpler-implementation).
- Faster [compilation time](https://cpp4r.r-lib.org/articles/motivations.html#compilation-speed) with lower memory requirements.
- Being *completely* [header only](https://cpp4r.r-lib.org/articles/motivations.html#header-only) to avoid ABI issues.
- Capable of [vendoring](https://cpp4r.r-lib.org/articles/motivations.html#vendoring) if desired.
- More robust [protection](https://cpp4r.r-lib.org/articles/motivations.html#protection) using a much more efficient linked list data structure.
- [Growing vectors](https://cpp4r.r-lib.org/articles/motivations.html#growing-vectors) more efficiently.

See [vignette("motivations")](https://cpp4r.r-lib.org/articles/motivations.html) for full details on the motivations for writing cpp4r.

## Conversion from Rcpp

See [vignette("converting")](https://cpp4r.r-lib.org/articles/converting.html) if you are already familiar with Rcpp or have an existing package that uses Rcpp and want to convert it to use cpp4r.

## Learning More

- [Welding R and C++](https://www.youtube.com/watch?v=_kq0N0FNIjA) - Presentation at SatRday Columbus [(slides)](https://speakerdeck.com/jimhester/cpp4r-welding-r-and-c-plus-plus)


## Internals

See [vignette("internals")](https://cpp4r.r-lib.org/articles/internals.html) for details on the cpp4r implementation or if you would like to contribute to cpp4r.

## Code of Conduct

Please note that the cpp4r project is released with a [Contributor Code of Conduct](https://cpp4r.r-lib.org/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

## Thanks

cpp4r would not exist without Rcpp.
Thanks to the Rcpp authors, Dirk Eddelbuettel, Romain Francois, JJ Allaire, Kevin Ushey, Qiang Kou, Nathan Russell, Douglas Bates and John Chambers for their work writing and maintaining Rcpp.

## Clang format

To match GHA, use clang-format-12 to format C++ code. With systems that provide clang-format-14 or newer, you can use Docker:

```bash
docker run --rm -v "$PWD":/work -w /work ubuntu:22.04 bash -lc "\
  apt-get update && apt-get install -y clang-format-12 && \
  find . -name '*.cpp' -o -name '*.hpp' -o -name '*.h' | xargs -r clang-format-12 -i"
```
