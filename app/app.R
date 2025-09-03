
library(shiny)
library(shinyWidgets)

# Load functions - CORRECT NAMES!
source("R/data_loader.R")
source("R/knn_s3.R")
source("R/knn_rcpp.R")

# Load data
data <- load_breast_cancer_data()
predictors <- setdiff(names(data), "diagnosis")

ui <- fluidPage(
  titlePanel("k-NN Breast Cancer Classification"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("k", "Number of neighbors (k):", min = 1, max = 20, value = 5),
      pickerInput("predictors", "Select predictors:",
                  choices = predictors,
                  selected = c("radius_mean", "texture_mean", "perimeter_mean"),
                  multiple = TRUE,
                  options = list(`actions-box` = TRUE)),
      radioButtons("dist", "Distance metric:",
                   choices = c("L2 (SSE)" = "sse", "L1 (SAD)" = "sad"),
                   selected = "sse"),
      radioButtons("implementation", "Implementation:",
                   choices = c("R" = "r", "Rcpp" = "rcpp"),
                   selected = "r"),
      actionButton("run", "Run Analysis")
    ),
    
    mainPanel(
      verbatimTextOutput("results")
    )
  )
)

server <- function(input, output) {
  
  # Split data
  split_data <- reactive({
    train_test_split(data)
  })
  
  observeEvent(input$run, {
    req(split_data())
    
    if (input$implementation == "r") {
      result <- knn_s3(
        train_data = split_data()$train,
        test_data = split_data()$test,
        k = input$k,
        dist = input$dist,
        predictors = input$predictors
      )
    } else {
      result <- knn_rcpp(
        train_data = split_data()$train,
        test_data = split_data()$test,
        k = input$k,
        dist = input$dist,
        predictors = input$predictors
      )
    }
    
    output$results <- renderPrint({
      print(result)
    })
  })
}

shinyApp(ui, server)

