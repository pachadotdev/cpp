pkgload::load_all("cpp4rtest")

bench::press(len = 10 ^ (0:7),
  {
    bench::mark(
      grow_(len)
    )
  }
)
