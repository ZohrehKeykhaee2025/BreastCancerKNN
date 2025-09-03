#' Load Breast Cancer Wisconsin Dataset
load_breast_cancer_data <- function(path = "data/wdbc.data") {
  if (!file.exists(path)) {
    message("Creating sample data...")
    set.seed(123)
    n <- 569
    return(data.frame(
      diagnosis = as.factor(sample(c("B", "M"), n, replace = TRUE, prob = c(0.63, 0.37))),
      radius_mean = rnorm(n, 14.13, 3.52),
      texture_mean = rnorm(n, 19.29, 4.30),
      perimeter_mean = rnorm(n, 91.97, 24.30)
    ))
  }
  
  data <- read.csv(path, header = FALSE)
  colnames(data) <- c("id", "diagnosis", "radius_mean", "texture_mean", "perimeter_mean")
  data$diagnosis <- as.factor(data$diagnosis)
  data <- data[, -1]
  return(data)
}

#' Create train/test split
train_test_split <- function(data, ratio = 0.7) {
  set.seed(123)
  train_idx <- sample(1:nrow(data), size = round(ratio * nrow(data)))
  return(list(train = data[train_idx, ], test = data[-train_idx, ]))
}

