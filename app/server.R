library(recipes)
library(shiny)
library(caret)
library(xgboost)
library(data.table)

xgb <- readRDS("xgb.RDS")
recipe <- readRDS("xgb_recipe.RDS")

# Define server logic to read selected file ----
function(input, output) {

  dataset <- reactive({
    req(input$file1)
    fread(input$file1$datapath, colClasses = c(
      date = "character",
      location = "character",
      mintemp = "numeric",
      maxtemp = "numeric",
      rainfall = "numeric",
      evaporation = "numeric",
      sunshine = "numeric",
      humidity9am = "integer",
      humidity3pm = "integer",
      pressure9am = "numeric",
      pressure3pm = "numeric",
      cloud9am = "integer",
      cloud3pm = "integer",
      temp9am = "numeric",
      temp3pm = "numeric",
      raintoday = "character",
      amountOfRain = "numeric",
      raintomorrow = "character",
      temp = "numeric",
      humidity = "numeric",
      precipitation3pm = "integer",
      precipitation9am = "numeric",
      modelo_vigente = "numeric",
      windgustdir = "character",
      windgustspeed = "integer",
      winddir9am = "character",
      winddir3pm = "character",
      windspeed9am = "integer",
      windspeed3pm = "integer"
    ))})

  output$dataset <- renderTable({
    return(head(dataset(), input$nrow))
  })

  observeEvent(input$runModel, {

    dataset_baked <- bake(recipe, dataset())
    pred <- predict(xgb, dataset_baked, na.action = na.pass, type = "prob")

    output$prediction <- renderTable({
      return(head(pred, input$nrow))
    })

    output$downloadpred <- downloadHandler(
      filename = "prediction.csv",
      content = function(file) {
        write.csv(pred, file, row.names = FALSE)
      }
    )
  }
  )
}
