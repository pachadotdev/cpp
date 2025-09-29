#pragma once

#include <cstring>
#include <string>
#include <vector>

// Davis: From what I can tell, you'd only ever define this if you need to include
// `declarations.hpp` manually in a file, i.e. to possibly use `BEGIN_cpp4r` with a
// custom `END_cpp4r`, as textshaping does do. Otherwise, `declarations.hpp` is included
// in `code.cpp` and should contain all of the cpp4r type definitions that the generated
// function signatures need to link against.
#ifndef cpp4r_PARTIAL
#include "cpp4r.hpp"
namespace writable = ::cpp4r::writable;
using namespace ::cpp4r;
#endif

#include <R_ext/Rdynload.h>

namespace cpp4r {
// No longer used, but was previously used in `code.cpp` code generation in cpp4r 0.1.0.
// `code.cpp` could be generated with cpp4r 0.1.0, but the package could be compiled with
// cpp4r >0.1.0, so `unmove()` must exist in newer cpp4r too. Eventually remove this once
// we decide enough time has gone by since `unmove()` was removed.
// https://github.com/r-lib/cpp4r/issues/88
// https://github.com/r-lib/cpp4r/pull/75
template <class T>
T& unmove(T&& t) {
  return t;
}
}  // namespace cpp4r

// We would like to remove this, since all supported versions of R now support proper
// unwind protect, but some groups rely on it existing, like textshaping:
// https://github.com/r-lib/cpp4r/issues/414
#define cpp4r_UNWIND R_ContinueUnwind(err);

#define cpp4r_ERROR_BUFSIZE 8192

#define BEGIN_cpp4r                   \
  SEXP err = R_NilValue;              \
  char buf[cpp4r_ERROR_BUFSIZE] = ""; \
  try {
#define END_cpp4r                                               \
  }                                                             \
  catch (cpp4r::unwind_exception & e) {                         \
    err = e.token;                                              \
  }                                                             \
  catch (std::exception & e) {                                  \
    strncpy(buf, e.what(), sizeof(buf) - 1);                    \
  }                                                             \
  catch (...) {                                                 \
    strncpy(buf, "C++ error (unknown cause)", sizeof(buf) - 1); \
  }                                                             \
  if (buf[0] != '\0') {                                         \
    Rf_errorcall(R_NilValue, "%s", buf);                        \
  } else if (err != R_NilValue) {                               \
    R_ContinueUnwind(err);                                      \
  }                                                             \
  return R_NilValue;
