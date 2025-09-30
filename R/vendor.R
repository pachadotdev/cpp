#' Vendor the cpp4r headers
#'
#' Vendoring is the act of making your own copy of the 3rd party packages your
#' project is using. It is often used in the go language community.
#'
#' This function vendors cpp4r into your package by copying the cpp4r
#' headers into the `inst/include` folder of your package and adding
#' 'cpp4r version: XYZ' to the top of the files, where XYZ is the version of
#' cpp4r currently installed on your machine.
#'
#' **Note**: vendoring places the responsibility of updating the code on
#' **you**. Bugfixes and new features in cpp4r will not be available for your
#' code until you run `cpp_vendor()` again.
#'
#' @inheritParams register
#' @param headers The subdirectory to vendor the headers into
#' @return The file path to the vendored code (invisibly).
#' @export
#' @examples
#' # create a new directory
#' dir <- paste0(tempdir(), "/", gsub("\\s+|[[:punct:]]", "", Sys.time()))
#' dir.create(dir, recursive = TRUE)
#'
#' # vendor the cpp4r headers into the directory
#' vendor(dir)
#'
#' list.files(file.path(dir, "inst", "include", "cpp4r"))
#'
#' # cleanup
#' unlink(dir, recursive = TRUE)
vendor <- function(path = ".", headers = "/inst/include") {
  if (is.null(path)) {
    stop("You must provide a path to vendor the code into", call. = FALSE)
  }

  path <- paste0(path, headers)

  path2 <- file.path(path, "cpp4r")
  if (dir.exists(path2)) {
    stop("'", path2, "' already exists\n * run unlink('", path2, "', recursive = TRUE)", call. = FALSE)
  }

  # Vendor cpp4r ----

  dir.create(
    path2,
    recursive = TRUE,
    showWarnings = FALSE
  )

  current_cpp4r <- system.file(
    "include",
    "cpp4r",
    package = "cpp4r"
  )

  if (!nzchar(current_cpp4r)) {
    stop("cpp4r is not installed", call. = FALSE)
  }

  cpp4r_version <- utils::packageVersion("cpp4r")

  cpp4r_header <- sprintf(
    "// cpp4r version: %s\n// vendored on: %s",
    cpp4r_version,
    Sys.Date()
  )

  write_header(
    path, "cpp4r.hpp", "cpp4r",
    cpp4r_header
  )

  copy_files(
    list.files(current_cpp4r, full.names = TRUE),
    path, "cpp4r", cpp4r_header
  )

  # Additional steps to make vendoring work ----

  message(paste(
    "Makevars and/or Makevars.win should have a line such as",
    "'PKG_CPPFLAGS = -I../inst/include'"
  ))

  message("DESCRIPTION should not have lines such as 'LinkingTo: cpp4r'")

  files <- list.files(headers, full.names = TRUE)

  invisible(path)
}

write_header <- function(path, header, pkg, cpp4rarmadillo_header) {
  writeLines(
    c(
      cpp4rarmadillo_header,
      readLines(
        system.file("include", header, package = pkg)
      )
    ),
    file.path(path, header)
  )
}

copy_files <- function(files, path, out, cpp4rarmadillo_header) {
  for (f in files) {
    writeLines(
      c(cpp4rarmadillo_header, readLines(f)),
      file.path(path, out, basename(f))
    )
  }
}
