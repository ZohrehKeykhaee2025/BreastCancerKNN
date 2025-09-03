# BreastCancerKNN
k-NN implementation for breast cancer diagnosis
Breast Cancer Wisconsin Diagnostic Classification with k-NN
Project Overview
This project implements a k-Nearest Neighbors (k-NN) classifier for the Breast Cancer Wisconsin Diagnostic dataset. The implementation includes both pure R and optimized Rcpp versions, along with a Shiny web application for interactive analysis.

# Features
Dual Distance Metrics: Support for both L1 (Manhattan) and L2 (Euclidean) distance measures

S3 Object-Oriented Implementation: Custom S3 classes with print and predict methods

Rcpp Optimization: High-performance C++ implementation for computational efficiency

Interactive Shiny App: Dynamic predictor selection and real-time analysis

Performance Benchmarking: Comprehensive comparison between R and Rcpp implementations

Download Functionality: Export predictions as CSV files

# Installation
# Prerequisites
install.packages(c("shiny", "shinyWidgets", "microbenchmark", "ggplot2", "Rcpp"))
# Clone and Setup
git clone https://github.com/zohrehkeykhaee2025/BreastCancerKNN.git
cd BreastCancerKNN
# Project Structure
BreastCancerKNN/
├── R/                    # R source files
│   ├── data_loader.R    # Data loading and preprocessing
│   ├── knn_s3.R         # S3 class implementation
│   └── knn_rcpp.R       # Rcpp interface
├── src/                 # C++ source code
│   └── knn_rcpp.cpp     # Rcpp optimized implementation
├── app/                 # Shiny application
│   └── app.R           # Interactive web interface
├── data/                # Dataset directory
│   └── wdbc.data       # Breast cancer dataset
├── benchmark_knn_dims.R # Performance tests
├── report.pdf          # Performance analysis report
└── README.md           # Project documentation
Usage
Basic Classification
# Load functions
source("R/data_loader.R")
source("R/knn_s3.R")
source("R/knn_rcpp.R")
Rcpp::sourceCpp("src/knn_rcpp.cpp")

# Load and prepare data
data <- load_breast_cancer_data()
split_data <- train_test_split(data, ratio = 0.7)

# Run classification with R
result_r <- knn_s3(split_data$train, split_data$test, k = 5, dist = "sse")
print(result_r)

# Run classification with Rcpp
result_rcpp <- knn_rcpp(split_data$train, split_data$test, k = 5, dist = "sse")
print(result_rcpp)
# Shiny Web Application
## Launch interactive app
shiny::runApp("app")
# The Shiny app provides:

.  Dynamic predictor selection

.  Adjustable k parameter (1-20)

.  Choice of distance metrics (L1/L2)

.  Implementation selection (R/Rcpp)

.  Real-time results display

.  Download predictions as CSV

# Performance Benchmarking
## Run performance tests
source("benchmark_knn_dims.R")

# Dataset Information
The Breast Cancer Wisconsin (Diagnostic) Dataset contains features computed from digitized images of fine needle aspirates (FNA) of breast masses. Features describe characteristics of the cell nuclei present in the image.

Number of instances: 569

Number of attributes: 30 (real-valued features)

Target variable: Diagnosis (M = malignant, B = benign)

# Key Results
Classification Performance
Accuracy with 3 predictors: ~90%

Accuracy with all predictors: ~85-90%

L2 distance showed better performance than L1 distance

# Speed Comparison
Rcpp implementation: ~16x faster than pure R

Average execution time (Rcpp): 650 microseconds

Average execution time (R): 10,539 microseconds

# Technical Implementation
 k-NN Algorithm
 The implementation supports:

Custom distance matrix calculation

Efficient neighbor selection

Majority voting for classification

Flexible parameter configuration

Rcpp Integration
Efficient memory management

Optimized distance calculations

Seamless R integration

Type safety and error handling

# Examples
Basic Usage
# Load data
data <- load_breast_cancer_data()

# Select specific predictors
predictors <- c("radius_mean", "texture_mean", "perimeter_mean")

# Perform classification
result <- knn_s3(data[1:300, ], data[301:400, ], 
                 k = 7, dist = "sad", predictors = predictors)
print(result)

# Benchmarking
# Compare performance
benchmark_results <- run_benchmark(
  sample_sizes = c(100, 200, 300),
  feature_counts = c(3, 5, 10),
  k = 5
)


## 🎯 Quick Start
### Run Complete Demo
```r
source("demo.R")

# Run Shiny App
source("run_shiny.R")

# Run Benchmarks
source("run_benchmark.R")
# Install Dependencies
source("install_dependencies.R")


## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

Please read our [Contributing Guidelines](CONTRIBUTING.md) for details.

# License
MIT License

Copyright (c) 2025 Zohreh Keykhaee

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

Author
Zohreh Keykhaee

GitHub: zohrehkeykhaee2025

Email: [keykhaeezohreh@gmail.com]

Acknowledgments
University of Wisconsin Hospitals for the Breast Cancer Wisconsin Diagnostic dataset

Rcpp development team for seamless C++ integration

RStudio team for Shiny framework

## 💬 Support

If you have any questions or need help, please:
- Open an [Issue](https://github.com/zohrehkeykhaee2025/BreastCancerKNN/issues)
- Contact via email: keykhaeezohreh@gmail.com