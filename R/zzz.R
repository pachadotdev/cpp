# From https://github.com/r-lib/vctrs/blob/a518ead0b08be29beea287d11e17edc1017e16da/R/zzz.R#L3
on_package_load <- function(pkg, expr) {
  if (isNamespaceLoaded(pkg)) {
    expr
  } else {
    thunk <- function(...) expr
    setHook(packageEvent(pkg, "onLoad"), thunk)
  }
}

# We need to set the cpp4r knitr engine when cpp4r is loaded.
.onLoad <- function(libname, pkgname) {
  on_package_load("knitr", {
    knitr::knit_engines$set(cpp4r = eng_cpp4r)
  })
}

release_bullets <- function() {
  c(
    '`Sys.setenv("cpp4r_EVAL" = "true"); devtools::submit_cran()`'
  )
}
