#include <R_ext/Random.h>
#include <cmath>
#include <cpp4r.hpp>
#include "Rmath.h"

using namespace cpp4r;

// RAII class to manage R's RNG state
class local_rng {
 public:
  local_rng() { GetRNGstate(); }

  ~local_rng() { PutRNGstate(); }
};

/* roxygen
@title Rejection Sampling from Truncated Normal Distribution
@description Demonstrates dynamic vector growth with rejection sampling - you don't know 
  how many samples you need to generate to get n_samples accepted values
@param n_samples Number of accepted samples desired
@param mu Mean of the normal distribution
@param sigma Standard deviation of the normal distribution  
@param lower Lower truncation bound
@param upper Upper truncation bound
@export
*/
[[cpp4r::register]] doubles rejection_sampling_cpp4r(int n_samples, double mu = 0.0, 
                                                     double sigma = 1.0, double lower = -2.0, 
                                                     double upper = 2.0) {
  // Manage R's RNG state
  local_rng rng_state;
  
  // Pre-calculate acceptance rate for better initial allocation
  double z_lower = (lower - mu) / sigma;
  double z_upper = (upper - mu) / sigma;
  double acceptance_rate = Rf_pnorm5(z_upper, 0.0, 1.0, 1, 0) - Rf_pnorm5(z_lower, 0.0, 1.0, 1, 0);
  
  // Pre-allocate based on expected number of samples needed
  // Add 20% buffer for variance + ensure minimum reasonable size
  R_xlen_t estimated_needed = static_cast<R_xlen_t>(n_samples / acceptance_rate * 1.2);
  estimated_needed = std::max(estimated_needed, static_cast<R_xlen_t>(n_samples));
  
  writable::doubles accepted_samples;
  accepted_samples.reserve(estimated_needed);
  
  // Keep sampling until we have enough accepted samples
  // Cast to int once for faster comparison in tight loop
  int target_samples = static_cast<int>(n_samples);
  
  while (static_cast<int>(accepted_samples.size()) < target_samples) {
    // Generate candidate from normal distribution
    double candidate = Rf_rnorm(mu, sigma);
    
    // Fast bounds check: single branch for most common case
    if (__builtin_expect(candidate >= lower && candidate <= upper, 1)) {
      accepted_samples.push_back(candidate);
    }
    // If rejected, we just continue sampling
  }
  
  return accepted_samples;
}

/* roxygen
@title Bootstrap Resampling with Variable Sample Sizes
@description Another natural use case for push_back - bootstrap sampling where
  sample sizes can vary based on some condition
@param data Original data vector
@param min_size Minimum bootstrap sample size
@param max_size Maximum bootstrap sample size  
@param n_bootstrap Number of bootstrap samples
@export
*/
[[cpp4r::register]] list bootstrap_variable_cpp4r(doubles data, int min_size, 
                                                  int max_size, int n_bootstrap) {
  local_rng rng_state;
  
  writable::list bootstrap_samples(n_bootstrap);
  int data_size = data.size();
  
  for (int b = 0; b < n_bootstrap; b++) {
    // Randomly determine sample size for this bootstrap
    int sample_size = min_size + (int)(Rf_runif(0, 1) * (max_size - min_size + 1));
    
    // Dynamic vector for this bootstrap sample
    writable::doubles boot_sample;
    
    // Sample with replacement
    for (int i = 0; i < sample_size; i++) {
      int idx = (int)(Rf_runif(0, 1) * data_size);
      boot_sample.push_back(data[idx]);
    }
    
    bootstrap_samples[b] = boot_sample;
  }
  
  return bootstrap_samples;
}
