
library(microbenchmark)
library(ggplot2)
library(Rcpp)

source("R/data_loader.R")
source("R/knn_s3.R")
source("R/knn_rcpp.R")
Rcpp::sourceCpp("src/knn_rcpp.cpp")

data <- load_breast_cancer_data()

# Benchmark function
run_benchmark <- function(sample_sizes, feature_counts, k = 5) {
  results <- data.frame()
  
  for (n in sample_sizes) {
    for (p in feature_counts) {
      if (p > 3) next  # فقط ۳ predictor داریم
      
      set.seed(123)
      sample_data <- data[sample(1:nrow(data), n), ]
      predictors <- c("radius_mean", "texture_mean", "perimeter_mean")[1:p]
      
      train_idx <- sample(1:n, size = round(0.7 * n))
      train_data <- sample_data[train_idx, ]
      test_data <- sample_data[-train_idx, ]
      
      bench <- microbenchmark(
        R = knn_s3(train_data, test_data, k = k, predictors = predictors),
        Rcpp = knn_rcpp(train_data, test_data, k = k, predictors = predictors),
        times = 5
      )
      
      bench_df <- as.data.frame(bench)
      bench_df$n <- n
      bench_df$p <- p
      results <- rbind(results, bench_df)
    }
  }
  return(results)
}

# اجرای بنچمارک
sample_sizes <- c(100, 200)
feature_counts <- c(2, 3)
benchmark_results <- run_benchmark(sample_sizes, feature_counts)

# ذخیره نتایج
write.csv(benchmark_results, "benchmark_results.csv", row.names = FALSE)
print(benchmark_results)

# visualization
p <- ggplot(benchmark_results, aes(x = factor(n), y = time/1000, fill = expr)) +
  geom_boxplot() +
  facet_wrap(~ p) +
  labs(title = "k-NN Performance Benchmark", x = "Sample Size", y = "Time (ms)") +
  theme_minimal()

ggsave("benchmark_plot.png", p)
print(p)

