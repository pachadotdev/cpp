library(cpp11benchgibbs)
library(cpp4rbenchgibbs)
library(Rcppbenchgibbs)
library(bench)
library(purrr)

cat("=== Benchmarking Dynamic Vector Growth with push_back ===\n")
cat("cpp4r/cpp11: Efficient - reserves extra space when growing vectors\n")
cat("Rcpp: Inefficient - copies entire vector on each push_back operation\n\n")

cat("=== 1. Rejection Sampling Performance ===\n")
cat("Perfect use case: We don't know how many candidates we'll need to generate\n")
cat("to get the desired number of accepted samples.\n\n")

# Test rejection sampling with different target sample sizes
rejection_sizes <- c(1000, 5000, 10000, 25000)

rejection_bench <- map_df(
  rejection_sizes,
  function(n_samples) {
    cat("Target samples:", n_samples, "\n")
    bench::mark(
      "cpp4r" = cpp4rbenchgibbs::rejection_sampling_cpp4r(n_samples, mu = 0, sigma = 1, lower = -1.5, upper = 1.5),
      "cpp11" = cpp11benchgibbs::rejection_sampling_cpp11(n_samples, mu = 0, sigma = 1, lower = -1.5, upper = 1.5),
      "Rcpp" = Rcppbenchgibbs::rejection_sampling_Rcpp(n_samples, mu = 0, sigma = 1, lower = -1.5, upper = 1.5),
      min_iterations = 5,
      max_iterations = 20,
      check = FALSE  # Results will differ due to randomness
    )
  }
)

print(rejection_bench[c("expression", "median", "mem_alloc", "n_itr")])

cat("\n=== 2. Bootstrap with Variable Sample Sizes ===\n")
cat("Another natural use case: Bootstrap samples with varying sizes\n\n")

# Create test data
test_data <- rnorm(1000)

bootstrap_bench <- bench::mark(
  "cpp4r" = cpp4rbenchgibbs::bootstrap_variable_cpp4r(test_data, min_size = 50, max_size = 200, n_bootstrap = 1000),
  "cpp11" = cpp11benchgibbs::bootstrap_variable_cpp11(test_data, min_size = 50, max_size = 200, n_bootstrap = 1000),
  "Rcpp" = Rcppbenchgibbs::bootstrap_variable_Rcpp(test_data, min_size = 50, max_size = 200, n_bootstrap = 1000),
  min_iterations = 3,
  max_iterations = 10,
  check = FALSE
)

print(bootstrap_bench[c("expression", "median", "mem_alloc", "n_itr")])

cat("\n=== Key Performance Insights ===\n")
cat("1. Rejection Sampling: Rcpp should show quadratic time complexity\n")
cat("   due to vector copying, while cpp4r/cpp11 remain linear\n")
cat("2. Memory Usage: Rcpp will allocate much more memory due to\n")
cat("   repeated copying of growing vectors\n")
cat("3. Real-world Impact: These patterns appear in Monte Carlo methods,\n")
cat("   adaptive algorithms, and data processing pipelines\n\n")

# Demonstrate the acceptance rate for rejection sampling
cat("=== Rejection Sampling Statistics ===\n")
set.seed(42)
sample1 <- cpp4rbenchgibbs::rejection_sampling_cpp4r(1000, mu = 0, sigma = 1, lower = -1.5, upper = 1.5)
acceptance_rate <- pnorm(1.5) - pnorm(-1.5)  # Theoretical acceptance rate
cat("Theoretical acceptance rate for [-1.5, 1.5] bounds:", round(acceptance_rate, 3), "\n")
cat("Average candidates needed per accepted sample:", round(1/acceptance_rate, 1), "\n")
cat("For 25,000 samples, expect ~", round(25000/acceptance_rate), "candidates to be generated\n")
