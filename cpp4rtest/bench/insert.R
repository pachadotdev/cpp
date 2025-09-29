pkgload::load_all("cpp4rtest")

bench::press(
  len = as.integer(10^(0:4)),
  {
    bench::mark(
      cpp4r_insert_(len)
    )
  }
)
