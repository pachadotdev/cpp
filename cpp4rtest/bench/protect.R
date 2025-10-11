pkgload::load_all("cpp4rtest")

bench::press(n = 10000,
  bench::mark(
    protect_one_(1:10, n),
    protect_one_cpp4r_(1:10, n),
    protect_one_sexp_(1:10, n),
    protect_one_preserve_(1:10, n)
  )
)

bench::press(n = 10000,
  bench::mark(
    protect_many_(n),
    protect_many_cpp4r_(n),
    protect_many_sexp_(n),
    protect_many_preserve_(n),
    protect_many_rcpp_(n)
  )
)
