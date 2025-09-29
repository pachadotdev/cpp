#include <numeric>
#include "cpp4r/doubles.hpp"

[[cpp4r::register]] double sum_dbl_for_(cpp4r::doubles x) {
  double sum = 0.;
  R_xlen_t n = x.size();
  for (R_xlen_t i = 0; i < n; ++i) {
    sum += x[i];
  }

  return sum;
}

[[cpp4r::register]] double sum_dbl_for2_(SEXP x_sxp) {
  double sum = 0.;
  const cpp4r::doubles x(x_sxp, false);
  R_xlen_t n = x.size();
  for (R_xlen_t i = 0; i < n; ++i) {
    sum += x[i];
  }

  return sum;
}

[[cpp4r::register]] double sum_dbl_for3_(SEXP x_sxp) {
  double sum = 0.;
  const cpp4r::writable::doubles x(x_sxp, false);
  R_xlen_t n = x.size();
  for (R_xlen_t i = 0; i < n; ++i) {
    sum += x[i];
  }

  return sum;
}

[[cpp4r::register]] double sum_dbl_foreach_(cpp4r::doubles x) {
  double sum = 0.;
  for (const auto&& val : x) {
    sum += val;
  }
  return sum;
}

[[cpp4r::register]] double sum_dbl_foreach2_(SEXP x_sxp) {
  const cpp4r::doubles x(x_sxp, false);
  double sum = 0.;
  for (const auto&& val : x) {
    sum += val;
  }
  return sum;
}

[[cpp4r::register]] double sum_dbl_accumulate_(cpp4r::doubles x) {
  return std::accumulate(x.cbegin(), x.cend(), 0.);
}

[[cpp4r::register]] double sum_dbl_accumulate2_(SEXP x_sxp) {
  const cpp4r::doubles x(x_sxp, false);
  return std::accumulate(x.cbegin(), x.cend(), 0.);
}
