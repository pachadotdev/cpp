#' @useDynLib cpp11sampling, .registration = TRUE
#' @keywords internal
"_PACKAGE"

#' @title Rejection Sampling from Truncated Normal Distribution (cpp11 version)
#' @description Generates samples from a truncated normal distribution using rejection sampling.
#'   This cpp11 implementation demonstrates efficient vector growth with push_back operations.
#' @param n_samples Number of accepted samples desired
#' @param mu Mean of the normal distribution. Default is 0.
#' @param sigma Standard deviation of the normal distribution. Default is 1.
#' @param lower Lower truncation bound. Default is -2.
#' @param upper Upper truncation bound. Default is 2.
#' @return A numeric vector of accepted samples from the truncated normal distribution
#' @export
rejection_sampling_cpp11 <- function(n_samples, mu = 0.0, sigma = 1.0, lower = -2.0, upper = 2.0) {
  rejection_sampling_cpp11_(n_samples, mu, sigma, lower, upper)
}

#' @title Bootstrap Resampling with Variable Sample Sizes (cpp11 version)
#' @description Performs bootstrap resampling where each bootstrap sample has a randomly
#'   determined size. Demonstrates efficient dynamic vector growth with cpp11.
#' @param data Original data vector to bootstrap from
#' @param min_size Minimum bootstrap sample size
#' @param max_size Maximum bootstrap sample size
#' @param n_bootstrap Number of bootstrap samples to generate
#' @return A list of bootstrap samples, each with a different random size
#' @export
bootstrap_variable_cpp11 <- function(data, min_size, max_size, n_bootstrap) {
  bootstrap_variable_cpp11_(data, min_size, max_size, n_bootstrap)
}
