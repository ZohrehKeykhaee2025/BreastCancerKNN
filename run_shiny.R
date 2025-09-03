# Shiny App Runner
cat("Launching Shiny App...\n")

# Load required packages
if (!require(shiny)) install.packages("shiny")
if (!require(shinyWidgets)) install.packages("shinyWidgets")

# Load project functions
source("R/data_loader.R")
source("R/knn_s3.R")
source("R/knn_rcpp.R")
Rcpp::sourceCpp("src/knn_rcpp.cpp")

# Run the app
shiny::runApp("app", launch.browser = TRUE)