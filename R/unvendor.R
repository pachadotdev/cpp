#' Unvendor the cpp4r headers
#'
#' This function removes the vendored cpp4r headers from your package by
#' automatically finding the vendored headers.
#'
#' @param path The directory with the vendored headers
#' @return The path to the unvendored code (invisibly).
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
#' unvendor()
#'
#' # cleanup
#' unlink(dir, recursive = TRUE)
unvendor <- function(path = "./src/vendor") {
  # Find the vendoring info file
  info_files <- list.files(path, pattern = "00-vendoring-info.txt", recursive = TRUE, full.names = TRUE)

  if (length(info_files) != 1L) {
    if (is_interactive()) { message("Could not find vendored headers") }
    return(invisible(NULL))
  }

  # The info file is in the cpp4r directory, so dirname(info_files) gives us the cpp4r directory
  cpp4r_dir <- dirname(info_files)
  # The parent of the cpp4r directory is where cpp4r.hpp should be
  parent_dir <- dirname(cpp4r_dir)
  
  # Remove the cpp4r directory
  unlink(cpp4r_dir, recursive = TRUE)

  # Remove cpp4r.hpp from the parent directory
  cpp4r_hpp_path <- file.path(parent_dir, "cpp4r.hpp")
  if (file.exists(cpp4r_hpp_path)) {
    unlink(cpp4r_hpp_path)
  }

  if (is_interactive()) {
    message("Unvendored cpp4r from '", parent_dir, "'")
    message("DESCRIPTION should link to cpp4r (e.g., 'LinkingTo: cpp4r')")
  }

  invisible(parent_dir)
}
