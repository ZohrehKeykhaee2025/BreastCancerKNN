#' Rcpp k-NN Wrapper
knn_rcpp <- function(train_data, test_data, k = 5, dist = "sse", predictors = NULL) {
  if (is.null(predictors)) predictors <- setdiff(names(train_data), "diagnosis")
  
  train_matrix <- as.matrix(train_data[, predictors])
  test_matrix <- as.matrix(test_data[, predictors])
  classes <- as.character(train_data$diagnosis)
  
  predictions <- knn_predict_rcpp(train_matrix, test_matrix, classes, k, dist)
  predictions <- factor(predictions, levels = levels(train_data$diagnosis))
  
  result <- list(predictions = predictions, actual = test_data$diagnosis, k = k, dist = dist)
  class(result) <- "knn_result"
  return(result)
}

