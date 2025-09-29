#include "cpp4r/doubles.hpp"
#include "cpp4r/integers.hpp"
#include "cpp4r/r_bool.hpp"
#include "cpp4r/r_string.hpp"

#include <testthat.h>

context("nas-C++") {
  test_that("na integer") { expect_true(cpp4r::na<int>() == NA_INTEGER); }
  test_that("na double") { expect_true(ISNA(cpp4r::na<double>())); }
  test_that("na bool") { expect_true(cpp4r::na<cpp4r::r_bool>() == NA_LOGICAL); }
  test_that("na string") { expect_true(cpp4r::na<cpp4r::r_string>() == NA_STRING); }
}
