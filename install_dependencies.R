# Install all dependencies
cat("Installing project dependencies...\n")

packages <- c("shiny", "shinyWidgets", "microbenchmark", "ggplot2", "Rcpp")

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

cat("All dependencies installed successfully!\n")