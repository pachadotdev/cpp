#' @title Rejection Sampling from Truncated Normal Distribution (R version)
#' @description Generates samples from a truncated normal distribution using rejection sampling.
#'   This R implementation demonstrates the same algorithm as the cpp4r version but will be slower
#'   due to the overhead of growing vectors in R.
#' @param n_samples Number of accepted samples desired
#' @param mu Mean of the normal distribution. Default is 0.
#' @param sigma Standard deviation of the normal distribution. Default is 1.
#' @param lower Lower truncation bound. Default is -2.
#' @param upper Upper truncation bound. Default is 2.
#' @return A numeric vector of accepted samples from the truncated normal distribution
#' @export
rejection_sampling <- function(n_samples, mu = 0.0, sigma = 1.0, lower = -2.0, upper = 2.0) {
  # Dynamic vector that grows as we accept samples
  accepted_samples <- numeric(0)
  
  # Keep sampling until we have enough accepted samples
  while (length(accepted_samples) < n_samples) {
    # Generate candidate from normal distribution
    candidate <- rnorm(1, mean = mu, sd = sigma)
    
    # Accept if within bounds
    if (candidate >= lower && candidate <= upper) {
      # This is inefficient in R - creates a new vector each time
      accepted_samples <- c(accepted_samples, candidate)
    }
    # If rejected, we just continue sampling - this is why we need dynamic growth!
  }
  
  return(accepted_samples)
}

#' @title Bootstrap Resampling with Variable Sample Sizes (R version)
#' @description Performs bootstrap resampling where each bootstrap sample has a randomly
#'   determined size. This demonstrates another natural use case for dynamic vector growth.
#' @param data Original data vector to bootstrap from
#' @param min_size Minimum bootstrap sample size
#' @param max_size Maximum bootstrap sample size
#' @param n_bootstrap Number of bootstrap samples to generate
#' @return A list of bootstrap samples, each with a different random size
#' @export
bootstrap_variable <- function(data, min_size, max_size, n_bootstrap) {
  bootstrap_samples <- vector("list", n_bootstrap)
  data_size <- length(data)
  
  for (b in seq_len(n_bootstrap)) {
    # Randomly determine sample size for this bootstrap - use runif to match cpp4r
    sample_size <- min_size + floor(runif(1) * (max_size - min_size + 1))
    
    # Dynamic vector for this bootstrap sample - inefficient growth in R!
    boot_sample <- numeric(0)
    
    # Sample with replacement - use runif to match cpp4r
    for (i in seq_len(sample_size)) {
      idx <- floor(runif(1) * data_size) + 1  # R uses 1-based indexing
      boot_sample <- c(boot_sample, data[idx]) # Creates new vector each time!
    }
    
    bootstrap_samples[[b]] <- boot_sample
  }
  
  return(bootstrap_samples)
}
