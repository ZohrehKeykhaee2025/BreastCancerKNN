
#' Load Breast Cancer Wisconsin Dataset
#'
#' @param path Path to the data file
#' @return A cleaned data frame
#' @export
load_breast_cancer_data <- function(path = "data/wdbc.data") {
  # Load the data
  data <- read.csv(path, header = FALSE)
  
  # Set column names based on the dataset documentation
  colnames(data) <- c("id", "diagnosis", 
                      "radius_mean", "texture_mean", "perimeter_mean", "area_mean", 
                      "smoothness_mean", "compactness_mean", "concavity_mean", 
                      "concave_points_mean", "symmetry_mean", "fractal_dimension_mean",
                      "radius_se", "texture_se", "perimeter_se", "area_se", 
                      "smoothness_se", "compactness_se", "concavity_se", 
                      "concave_points_se", "symmetry_se", "fractal_dimension_se",
                      "radius_worst", "texture_worst", "perimeter_worst", "area_worst", 
                      "smoothness_worst", "compactness_worst", "concavity_worst", 
                      "concave_points_worst", "symmetry_worst", "fractal_dimension_worst")
  
  # Convert diagnosis to factor (M = Malignant, B = Benign)
  data$diagnosis <- as.factor(data$diagnosis)
  
  # Remove ID column
  data <- data[, -1]
  
  return(data)
}

#' Create train/test split
#'
#' @param data Full dataset
#' @param ratio Training ratio (default: 0.7)
#' @return List with train and test data
#' @export
train_test_split <- function(data, ratio = 0.7) {
  set.seed(123)
  train_idx <- sample(1:nrow(data), size = round(ratio * nrow(data)))
  
  return(list(
    train = data[train_idx, ],
    test = data[-train_idx, ]
  ))
}

