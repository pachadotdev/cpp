#define cpp4r_USE_FMT
#include "cpp4r/function.hpp"
#include "cpp4r/protect.hpp"
using namespace cpp4r;

[[cpp4r::register]] void my_stop(std::string mystring, int myarg) {
  cpp4r::stop(mystring, myarg);
}
[[cpp4r::register]] void my_stop_n1(std::string mystring) { cpp4r::stop(mystring); }
[[cpp4r::register]] void my_warning(std::string mystring, std::string myarg) {
  cpp4r::warning(mystring, myarg);
}
[[cpp4r::register]] void my_warning_n1(std::string mystring) { cpp4r::warning(mystring); }
[[cpp4r::register]] void my_message(std::string mystring, std::string myarg) {
  cpp4r::message(mystring, myarg);
}
[[cpp4r::register]] void my_message_n1(std::string mystring) { cpp4r::message(mystring); }
