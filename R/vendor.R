#' Vendor the cpp4r dependency
#'
#' Vendoring is the act of making your own copy of the 3rd party packages your
#' project is using. It is often used in the go language community.
#'
#' This function vendors cpp4r into your package by copying the cpp4r
#' headers into the `inst/include` folder of your package and adding
#' 'cpp4r version: XYZ' to the top of the files, where XYZ is the version of
#' cpp4r currently installed on your machine.
#'
#' If you choose to vendor the headers you should _remove_ `LinkingTo:
#' cpp4r` from your DESCRIPTION.
#'
#' **Note**: vendoring places the responsibility of updating the code on
#' **you**. Bugfixes and new features in cpp4r will not be available for your
#' code until you run `cpp_vendor()` again.
#'
#' @inheritParams cpp_register
#' @return The file path to the vendored code (invisibly).
#' @export
#' @examples
#' # create a new directory
#' dir <- tempfile()
#' dir.create(dir)
#'
#' # vendor the cpp4r headers into the directory
#' cpp_vendor(dir)
#'
#' list.files(file.path(dir, "inst", "include", "cpp4r"))
#'
#' # cleanup
#' unlink(dir, recursive = TRUE)
cpp_vendor <- function(path = ".") {
  new <- file.path(path, "inst", "include", "cpp4r")

  if (dir.exists(new)) {
    stop("'", new, "' already exists\n * run unlink('", new, "', recursive = TRUE)", call. = FALSE)
  }

  dir.create(new , recursive = TRUE, showWarnings = FALSE)

  current <- system.file("include", "cpp4r", package = "cpp4r")
  if (!nzchar(current)) {
    stop("cpp4r is not installed", call. = FALSE)
  }

  cpp4r_version <- utils::packageVersion("cpp4r")

  cpp4r_header <- sprintf("// cpp4r version: %s\n// vendored on: %s", cpp4r_version, Sys.Date())

  files <- list.files(current, full.names = TRUE)

  writeLines(
    c(cpp4r_header, readLines(system.file("include", "cpp4r.hpp", package = "cpp4r"))),
    file.path(dirname(new), "cpp4r.hpp")
  )

  for (f in files) {
    writeLines(c(cpp4r_header, readLines(f)), file.path(new, basename(f)))
  }

  invisible(new)
}
