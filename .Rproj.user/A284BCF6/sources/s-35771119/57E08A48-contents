library(dplyr)
library(recipes)
library(caret)
library(doParallel)
library(e1071)

source('r_functions/load_rain_dataset.R')
rain <- load_rain_dataset()

set.seed(42)
inTrain <- createDataPartition(rain$raintomorrow, p=0.75, list=FALSE)
training <- rain[inTrain,]
testing <- rain[-inTrain,]

rain_recipe <-
  recipe(
    raintomorrow ~ .,
    data = training
  ) %>%
  step_mutate(
    tempamplitude = maxtemp - mintemp,
    humiditychange = humidity3pm - humidity9am,
    pressurechange = pressure3pm - pressure9am
  ) %>%
  step_rm(cloud9am, cloud3pm, sunshine, evaporation,
          amountOfRain, date, location) %>%
  step_corr(all_numeric()) %>%
  step_nzv(-all_outcomes()) %>%
  step_medianimpute(all_numeric()) %>%
  step_modeimpute(all_nominal()) %>%
  prep()

training_baked <- juice(rain_recipe)

train_control <- trainControl(
  method = "cv",
  number = 5,
  verboseIter = TRUE,
  summaryFunction = twoClassSummary,
  classProbs = TRUE
)

# https://csantill.github.io/RTuningModelParameters/

cl <- makePSOCKcluster(6)
registerDoParallel(cl)

set.seed(42)
rpart <- train(raintomorrow ~ .,
                data = training_baked,
                method = "rpart",
                na.action = na.pass,
                trControl = train_control)
stopCluster(cl)

# saveRDS(rpart, "modelling/rpart.RDS")

