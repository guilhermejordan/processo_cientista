library(recipes)
library(shiny)
library(caret)
library(xgboost)
library(data.table)

xgb <- readRDS("xgb.rds")
recipe <- readRDS("xgb_recipe.RDS")

# Define server logic to read selected file ----
function(input, output) {

  datasetInput <-
    eventReactive(input$Run_Model,{
      req(input$file1)
      col_classes <-
        c(
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
        )
      dataset <-
        fread(input$file1$datapath, colClasses = col_classes)

      return(dataset)
    })


  observeEvent(input$Run_Model,


    dataset_baked <- bake(recipe, datasetInput()),
    prediction_probs <- predict(xgb, dataset_baked, na.action = na.pass, type = "prob"),

    output$dataset <- renderTable({
      return(head(datasetInput()))
    }),

    output$prediction <- renderTable({
      return(head(prediction_probs))
    }),

    output$downloadData <- downloadHandler(
        filename = "prediction.csv",
        content = function(file) {
          write.csv(datasetInput(), file, row.names = FALSE)
        }
      )
  )

}
