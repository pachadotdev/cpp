#' @title Rejection Sampling from Truncated Normal Distribution (Rcpp version)
#' @description Generates samples from a truncated normal distribution using rejection sampling.
#'   This Rcpp implementation demonstrates the inefficiency of push_back operations in Rcpp
#'   due to vector copying on each growth operation.
#' @param n_samples Number of accepted samples desired
#' @param mu Mean of the normal distribution. Default is 0.
#' @param sigma Standard deviation of the normal distribution. Default is 1.
#' @param lower Lower truncation bound. Default is -2.
#' @param upper Upper truncation bound. Default is 2.
#' @return A numeric vector of accepted samples from the truncated normal distribution
#' @export
rejection_sampling_Rcpp <- function(n_samples, mu = 0.0, sigma = 1.0, lower = -2.0, upper = 2.0) {
  rejection_sampling_Rcpp_(n_samples, mu, sigma, lower, upper)
}

#' @title Bootstrap Resampling with Variable Sample Sizes (Rcpp version)
#' @description Performs bootstrap resampling where each bootstrap sample has a randomly
#'   determined size. Demonstrates the inefficiency of Rcpp's push_back operations.
#' @param data Original data vector to bootstrap from
#' @param min_size Minimum bootstrap sample size
#' @param max_size Maximum bootstrap sample size
#' @param n_bootstrap Number of bootstrap samples to generate
#' @return A list of bootstrap samples, each with a different random size
#' @export
bootstrap_variable_Rcpp <- function(data, min_size, max_size, n_bootstrap) {
  bootstrap_variable_Rcpp_(data, min_size, max_size, n_bootstrap)
}
