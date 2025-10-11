#include <R_ext/Random.h>
#include <cmath>
#include <cpp11.hpp>
#include "Rmath.h"

using namespace cpp11;

// RAII class to manage R's RNG state
class local_rng {
 public:
  local_rng() { GetRNGstate(); }

  ~local_rng() { PutRNGstate(); }
};

[[cpp11::register]] cpp11::writable::doubles rejection_sampling_cpp11_(
    int n_samples, double mu = 0.0, double sigma = 1.0, 
    double lower = -2.0, double upper = 2.0) {
  // Manage R's RNG state
  local_rng rng_state;
  
  // Dynamic vector that grows as we accept samples
  cpp11::writable::doubles accepted_samples;
  
  // Keep sampling until we have enough accepted samples
  while (accepted_samples.size() < n_samples) {
    // Generate candidate from normal distribution
    double candidate = Rf_rnorm(mu, sigma);
    
    // Accept if within bounds
    if (candidate >= lower && candidate <= upper) {
      accepted_samples.push_back(candidate);
    }
    // If rejected, we just continue sampling - this is why we need dynamic growth!
  }
  
  return accepted_samples;
}

[[cpp11::register]] cpp11::writable::list bootstrap_variable_cpp11_(
    cpp11::doubles data, int min_size, int max_size, int n_bootstrap) {
  local_rng rng_state;
  
  cpp11::writable::list bootstrap_samples(n_bootstrap);
  int data_size = data.size();
  
  for (int b = 0; b < n_bootstrap; b++) {
    // Randomly determine sample size for this bootstrap
    int sample_size = min_size + (int)(Rf_runif(0, 1) * (max_size - min_size + 1));
    
    // Dynamic vector for this bootstrap sample
    cpp11::writable::doubles boot_sample;
    
    // Sample with replacement
    for (int i = 0; i < sample_size; i++) {
      int idx = (int)(Rf_runif(0, 1) * data_size);
      boot_sample.push_back(data[idx]);
    }
    
    bootstrap_samples[b] = boot_sample;
  }
  
  return bootstrap_samples;
}
