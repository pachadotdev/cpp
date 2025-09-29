describe("eng_cpp4r", {
  it("works when code is not evaluated", {
    skip_on_os("solaris")
    opts <- knitr::opts_chunk$get()
    opts <- utils::modifyList(opts, list(eval = FALSE, engine = "cpp4r", code = "1 + 1"))

    expect_equal(
      eng_cpp4r(opts),
      "1 + 1"
    )
  })

  it("works when code is evaluated", {
    skip_on_os("solaris")
    opts <- knitr::opts_chunk$get()
    code <- "[[cpp4r::register]] int foo() { return 0; }"
    opts <- utils::modifyList(opts, list(eval = TRUE, engine = "cpp4r", code = code, quiet = TRUE))

    expect_equal(
      eng_cpp4r(opts),
      code
    )
  })
})
