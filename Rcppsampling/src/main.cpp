#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
NumericVector rejection_sampling_Rcpp_(int n_samples, double mu = 0.0, double sigma = 1.0,
                                     double lower = -2.0, double upper = 2.0) {
  // Dynamic vector that grows as we accept samples
  NumericVector accepted_samples;
  
  // Keep sampling until we have enough accepted samples
  while (accepted_samples.size() < n_samples) {
    // Generate candidate from normal distribution
    double candidate = Rf_rnorm(mu, sigma);
    
    // Accept if within bounds
    if (candidate >= lower && candidate <= upper) {
      // This is VERY inefficient in Rcpp - copies entire vector each time!
      accepted_samples.push_back(candidate);
    }
    // If rejected, we just continue sampling - this is why we need dynamic growth!
  }
  
  return accepted_samples;
}

// [[Rcpp::export]]
List bootstrap_variable_Rcpp_(NumericVector data, int min_size, int max_size, int n_bootstrap) {
  List bootstrap_samples(n_bootstrap);
  int data_size = data.size();
  
  for (int b = 0; b < n_bootstrap; b++) {
    // Randomly determine sample size for this bootstrap
    int sample_size = min_size + (int)(Rf_runif(0, 1) * (max_size - min_size + 1));
    
    // Dynamic vector for this bootstrap sample - inefficient growth in Rcpp!
    NumericVector boot_sample;
    
    // Sample with replacement
    for (int i = 0; i < sample_size; i++) {
      int idx = (int)(Rf_runif(0, 1) * data_size);
      boot_sample.push_back(data[idx]); // Copies entire vector each time!
    }
    
    bootstrap_samples[b] = boot_sample;
  }
  
  return bootstrap_samples;
}
