# BreastCancerKNN - Demonstration Script
# Author: Zohreh Keykhaee
# Date: 2025

cat("=== Breast Cancer k-NN Classification Demo ===\n\n")

# 1. Load required packages
cat("1. Loading required packages...\n")
install.packages(c("shiny", "shinyWidgets", "microbenchmark", "ggplot2", "Rcpp"))
library(shiny)
library(shinyWidgets)
library(microbenchmark)
library(ggplot2)
library(Rcpp)

# 2. Load project functions
cat("2. Loading project functions...\n")
source("R/data_loader.R")
source("R/knn_s3.R")
source("R/knn_rcpp.R")

# 3. Compile Rcpp code
cat("3. Compiling Rcpp code...\n")
Rcpp::sourceCpp("src/knn_rcpp.cpp")

# 4. Load and explore data
cat("4. Loading breast cancer data...\n")
data <- load_breast_cancer_data()
cat("   Dataset dimensions:", dim(data), "\n")
cat("   Diagnosis distribution:\n")
print(table(data$diagnosis))

# 5. Train-test split
cat("5. Creating train-test split...\n")
split_data <- train_test_split(data, ratio = 0.7)
cat("   Training samples:", nrow(split_data$train), "\n")
cat("   Testing samples:", nrow(split_data$test), "\n")

# 6. Run k-NN with R implementation
cat("6. Running k-NN with R implementation...\n")
predictors <- c("radius_mean", "texture_mean", "perimeter_mean")
result_r <- knn_s3(
  train_data = split_data$train,
  test_data = split_data$test,
  k = 5,
  dist = "sse",
  predictors = predictors
)
cat("   R implementation results:\n")
print(result_r)

# 7. Run k-NN with Rcpp implementation
cat("7. Running k-NN with Rcpp implementation...\n")
result_rcpp <- knn_rcpp(
  train_data = split_data$train,
  test_data = split_data$test,
  k = 5,
  dist = "sse",
  predictors = predictors
)
cat("   Rcpp implementation results:\n")
print(result_rcpp)

# 8. Performance comparison
cat("8. Performance benchmark...\n")
benchmark_results <- microbenchmark(
  R = knn_s3(split_data$train, split_data$test, k = 5, predictors = predictors),
  Rcpp = knn_rcpp(split_data$train, split_data$test, k = 5, predictors = predictors),
  times = 10
)
cat("   Benchmark results:\n")
print(benchmark_results)

# 9. Visualization
cat("9. Creating performance plot...\n")
p <- ggplot(benchmark_results, aes(x = expr, y = time/1000, fill = expr)) +
  geom_boxplot() +
  labs(title = "k-NN Performance: R vs Rcpp",
       x = "Implementation",
       y = "Time (milliseconds)",
       fill = "Implementation") +
  theme_minimal()

ggsave("performance_plot.png", p, width = 8, height = 6)
cat("   Plot saved as 'performance_plot.png'\n")

# 10. Run Shiny app (optional)
cat("10. To run Shiny app, execute: shiny::runApp('app')\n")
cat("    Or run: source('run_shiny.R')\n")

cat("\n=== Demo completed successfully! ===\n")