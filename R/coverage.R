cpp4r_coverage <- function(...) {
  old <- options(covr.filter_non_package = FALSE, covr.gcov_additional_paths = ".*/cpp4r/")
  on.exit(options(old))

  cpp4r_coverage <- covr::package_coverage(".", ...)

  cpp4rtest_coverage <- covr::package_coverage("cpp4rtest", ...)

  cpp4rtest_coverage <- cpp4rtest_coverage[grepl("include/cpp4r", covr::display_name(cpp4rtest_coverage))]
  attr(cpp4rtest_coverage, "package")$path <- sub("cpp4r/include.*", "cpp4r", covr::display_name(cpp4rtest_coverage)[[1]])

  cov <- c(cpp4r_coverage, cpp4rtest_coverage)
  attributes(cov) <- attributes(cpp4r_coverage)

  cov
}
