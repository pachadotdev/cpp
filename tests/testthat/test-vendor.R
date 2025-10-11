describe("vendor", {
  it("errors if cpp4r is not installed", {
    pkg <- local_package()
    mockery::stub(vendor, "system.file", "")
    expect_error(
      vendor(pkg_path(pkg)),
      "cpp4r is not installed"
    )
  })

  it("errors if cpp4r is already vendored", {
    pkg <- local_package()
    vendor(pkg_path(pkg))

    expect_error(
      vendor(pkg_path(pkg)),
      "already exists"
    )
  })

  it("vendor cpp4r to non-default directory", {
    pkg <- local_package()
    p <- paste(pkg_path(pkg), "inst", "include", sep = "/")

    vendor(p)

    expect_true(dir.exists(file.path(p, "cpp4r")))
    expect_true(file.exists(file.path(p, "cpp4r.hpp")))
    expect_true(file.exists(file.path(p, "cpp4r", "declarations.hpp")))

    expect_invisible(unvendor(p))
  })
})

describe("unvendor", {
  it("unvendor without errors", {
    pkg <- local_package()
    p <- paste(pkg_path(pkg), "inst", "include", sep = "/")

    vendor(p)
    expect_true(dir.exists(file.path(p, "cpp4r")))
    expect_true(file.exists(file.path(p, "cpp4r.hpp")))
    expect_true(file.exists(file.path(p, "cpp4r", "declarations.hpp")))

    expect_invisible(unvendor(p))

    expect_false(dir.exists(file.path(p, "cpp4r")))
    expect_false(file.exists(file.path(p, "cpp4r.hpp")))
    expect_false(file.exists(file.path(p, "cpp4r", "declarations.hpp")))
  })
})
