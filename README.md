
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cpp4r

<img src="man/figures/logo.svg" height="139" alt="" />

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![R-CMD-check](https://github.com/pachadotdev/cpp4r/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pachadotdev/cpp4r/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/cpp4r)](https://CRAN.R-project.org/package=cpp4r)
[![Test
coverage](https://raw.githubusercontent.com/pachadotdev/cpp4r/main/badges/coverage.svg)](https://github.com/pachadotdev/cpp4r/actions/workflows/test-coverage.yaml)
[![BuyMeACoffee](https://raw.githubusercontent.com/pachadotdev/buymeacoffee-badges/main/bmc-yellow.svg)](https://buymeacoffee.com/pacha)
<!-- badges: end -->

cpp4r helps you to interact with R objects using C++ code. It is a fork
of the [cpp11](https://cran.r-project.org/package=cpp11) package with
identical syntax and similar goals.

⚠️Important⚠️: cpp4r was created to ease writing functions in your own
packages and does not offer on-the-fly compilation for code snippets.

cpp4r can be used as a replacement for cpp11 in existing or new
packages. Think of cpp11 and cpp4r as MySQL and MariaDB: they are almost
identical, but cpp4r has some extra features.

After discussing some [pull
requests](https://github.com/pachadotdev/cpp11/pulls/pachadotdev) with
Hadley Wickham from Posit, it was mentioned that I should create my own
fork to add the following features:

- [x] Convert ordered and unordered C++ maps to R lists.
- [x] Roxygen support on C++ side.
- [x] Allow `dimnames` attribute with matrices on C++ side.
- [x] Support nullable `external_ptr<>`.
- [x] Use values added to a vector with `push_back()` immediately.
- [x] Support bidirectional passing of complex numbers/vectors.
- [x] Provide flexibility with data types (e.g., cpp4r’s `as_integers()`
  and `as_doubles()` accept logical inputs while cpp11’s do not).
- [x] Some internal optimizations for better speed (e.g.,
  <https://github.com/r-lib/cpp11/pull/463> and
  <https://github.com/r-lib/cpp11/pull/430>).

## Getting started

Check the [documentation](https://cpp4r.org/) to get started using cpp4r
in your scripts, particularly if you are new to C++ programming.

## Using cpp4r in a package

Create a new package with `cpp4r::pkg_template("~/path/to/mypkg")` and
then edit the generated files.

To add cpp4r to an existing package, put your C++ files in the `src/`
directory and add the following to your DESCRIPTION file:

    LinkingTo: cpp4r

Then add a roxygen header, for example, to `R/mypkg-package.R`:

``` r
#' @useDynLib mypkg, .registration = TRUE
#' @keywords internal
"_PACKAGE"
```

Then decorate C++ functions you want to expose to R with
`[[cpp4r::register]]`.

cpp4r is a header only library with no hard dependencies and does not
use a shared library. It is straightforward and reliable to use in
packages without fear of compile-time and run-time mismatches.

## Vendoring

You can [vendor](https://cpp4r.org/articles/01-motivations.html) the
current installed version of cpp4r headers into your package with
`cpp4r::vendor()`.

The
[cpp4rvendor](https://github.com/pachadotdev/cpp4r/tree/main/cpp4rtest)
package shows an example of vendoring cpp4r headers.

Vendoring ensures the headers will remain unchanged until you explicitly
update them. The advantage is that your package will not break if there
are breaking changes in future versions of cpp4r. The disadvantage is
that you will not get bug fixes and new features unless you update the
vendored headers.

## Getting help

Please open an issue or email me. I will do my best to respond before 48
hours.

## Contributing

Contributions are welcome! Please see the [internals
vignette](https://cpp4r.org/articles/15-internals.html) for details
about design choices and coding style.

## Code of Conduct

Please note that the cpp4r project is released with a [Contributor Code
of Conduct](https://cpp4r.org/CODE_OF_CONDUCT.html). By contributing to
this project, you agree to abide by its terms.
