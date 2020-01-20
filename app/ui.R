library(shiny)

# Define UI for prediction app ----
fluidPage(

  # App title ----
  titlePanel("Predict rain in Australia"),


    # Sidebar panel for inputs ----
  mainPanel(

    # Input: Select a file ----
    fileInput("file1", "Upload CSV File for prediction",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),

    numericInput(
      "nrow",
      "Show how many rows?",
      value = 5,
      min = 1,
      max = 100,
      step = 25
    ),

    # Horizontal line ----
    tags$hr(),

    # Output: input data file ----
    tableOutput("dataset"),

    # Input: Run model ----
    actionButton("runModel", "Predict"),

    # Output: prediction ----
    tableOutput("prediction"),

    # Input: download button
    downloadButton("downloadpred", "Download prediction")

  )


)


