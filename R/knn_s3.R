#' k-NN Classifier with S3 Methods
knn_s3 <- function(train_data, test_data, k = 5, dist = "sse", predictors = NULL) {
  if (is.null(predictors)) predictors <- setdiff(names(train_data), "diagnosis")
  
  distances <- apply(test_data[, predictors], 1, function(x) {
    if (dist == "sse") rowSums((train_data[, predictors] - x)^2)
    else rowSums(abs(train_data[, predictors] - x))
  })
  
  neighbors <- apply(distances, 2, function(x) order(x)[1:k])
  predictions <- apply(neighbors, 2, function(idx) {
    names(which.max(table(train_data$diagnosis[idx])))
  })
  
  predictions <- factor(predictions, levels = levels(train_data$diagnosis))
  
  result <- list(predictions = predictions, actual = test_data$diagnosis, k = k, dist = dist)
  class(result) <- "knn_result"
  return(result)
}

print.knn_result <- function(x, ...) {
  cat("k-NN Result - Accuracy:", mean(x$predictions == x$actual), "\n")
}

