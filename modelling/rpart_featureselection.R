library(dplyr)
library(recipes)
library(caret)
library(doParallel)
library(e1071)
library(prodlim)

source('r_functions/load_rain_dataset.R')
rain <- load_rain_dataset()

set.seed(42)
inTrain <-
  createDataPartition(rain$raintomorrow, p = 0.5, list = FALSE)
training <- rain[inTrain, ]
testing <- rain[-inTrain, ]

rain_recipe <-
  recipe(raintomorrow ~ .,
         data = training) %>%
  step_rm(amountOfRain, modelo_vigente) %>%
  step_mutate(
    tempamplitude = maxtemp - mintemp,
    tempchange = temp3pm - temp9am,
    humiditychange = humidity3pm - humidity9am,
    pressurechange = pressure3pm - pressure9am,
    precipitationchange = precipitation3pm - precipitation9am,
  ) %>%
  step_medianimpute(all_numeric(),-sunshine,-evaporation,-cloud3pm,-cloud9am) %>%
  step_modeimpute(all_nominal()) %>%
  step_knnimpute(sunshine, evaporation, cloud3pm, cloud9am) %>%
  prep()

training_baked <- juice(rain_recipe)

cl <- makePSOCKcluster(4)
registerDoParallel(cl)

set.seed(42)
rpart <- train(
  raintomorrow ~ .,
  data = training_baked,
  method = "rpart",
  na.action = na.pass
)
stopCluster(cl)

saveRDS(rpart, "modelling/rpart_featureselection.RDS")
