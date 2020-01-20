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

    # Horizontal line ----
    tags$hr(),


    # Input: Run model ----
    actionButton("Run_Model", "Predict"),

    # Output: input data file ----
    tableOutput("dataset"),

    # Output: prediction ----
    tableOutput("prediction"),

    # Input: download button
    downloadButton("downloadData", "Download")

  )


)


