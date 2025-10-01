#include "Rcpp.h"

[[cpp4r::register]] void cpp4r_release_(int n) {
  std::vector<cpp4r::sexp> x;
  int count = 0;
  while (count < n) {
    x.push_back(Rf_ScalarInteger(count));
    ++count;
  }
  count = 0;
  while (count < n) {
    x.pop_back();
    ++count;
  }
}

[[cpp4r::register]] void Rcpp_release_(int n) {
  std::vector<Rcpp::RObject> x;
  int count = 0;
  while (count < n) {
    x.push_back(Rcpp::RObject(Rf_ScalarInteger(count)));
    ++count;
  }
  count = 0;
  while (count < n) {
    x.pop_back();
    ++count;
  }
}
