#' Unvendor the cpp4r headers
#'
#' This function removes the vendored cpp4r headers from your package and
#' restores the `LinkingTo: cpp4r` field in the DESCRIPTION file if it was removed.
#'
#' @inheritParams register
#' @return The file path to the unvendored code (invisibly).
#' @export
#' @examples
#' # create a new directory
#' dir <- tempfile()
#' dir.create(dir)
#'
#' # vendor the cpp4r headers into the directory
#' vendor(dir)
#'
#' # unvendor the cpp4r headers from the directory
#' unvendor(dir)
#'
#' list.files(file.path(dir, "inst", "include", "cpp4r"))
#'
#' # cleanup
#' unlink(dir, recursive = TRUE)
unvendor <- function(path = ".") {
  new <- file.path(path, "inst", "include", "cpp4r")

  if (!dir.exists(new)) {
    stop("'", new, "' does not exist", call. = FALSE)
  }

  unlink(new, recursive = TRUE)

  cpp4r_hpp <- file.path(dirname(new), "cpp4r.hpp")
  if (file.exists(cpp4r_hpp)) {
    unlink(cpp4r_hpp)
  }

  invisible(new)
}
