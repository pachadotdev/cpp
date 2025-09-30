describe("vendor", {
  it("errors if cpp4r is not installed", {
    pkg <- local_package()
    mockery::stub(vendor, "system.file", "")
    expect_error(
      vendor(pkg_path(pkg)),
      "cpp4r is not installed"
    )
  })

  # it("errors if cpp4r is already vendored", {
  #   pkg <- local_package()
  #   vendor(pkg_path(pkg))

  #   expect_error(
  #     vendor(pkg_path(pkg)),
  #     "already exists"
  #   )
  # })

  it("vendors cpp4r", {
    pkg <- local_package()
    p <- pkg_path(pkg)

    vendor(pkg_path(pkg))

    expect_true(dir.exists(file.path(p, "inst", "include", "cpp4r")))
    expect_true(file.exists(file.path(p, "inst", "include", "cpp4r.hpp")))
    expect_true(file.exists(file.path(p, "inst", "include", "cpp4r", "declarations.hpp")))
    expect_silent(unvendor(pkg_path(pkg)))
  })
})

describe("unvendor", {
  it("errors if the path does not exist", {
    pkg <- local_package()
    expect_error(
      unvendor(pkg_path(pkg)),
      "does not exist"
    )
  })

  it("unvendors cpp4r", {
    pkg <- local_package()
    p <- pkg_path(pkg)

    vendor(pkg_path(pkg))
    expect_true(dir.exists(file.path(p, "inst", "include", "cpp4r")))
    expect_true(file.exists(file.path(p, "inst", "include", "cpp4r.hpp")))
    expect_true(file.exists(file.path(p, "inst", "include", "cpp4r", "declarations.hpp")))

    expect_silent(unvendor(pkg_path(pkg)))

    expect_false(dir.exists(file.path(p, "inst", "include", "cpp4r")))
    expect_false(file.exists(file.path(p, "inst", "include", "cpp4r.hpp")))
    expect_false(file.exists(file.path(p, "inst", "include", "cpp4r", "declarations.hpp")))
  })
})
