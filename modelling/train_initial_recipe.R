library(dplyr)
library(recipes)
library(caret)

source('r_functions/load_rain_dataset.R')
rain <- load_rain_dataset()

set.seed(42)
inTrain <- createDataPartition(rain$raintomorrow, p = 0.3, list = FALSE)
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
  step_corr(all_numeric()) %>%
  step_nzv(-all_outcomes()) %>%
  step_medianimpute(all_numeric(),-sunshine,-evaporation,-cloud3pm,-cloud9am) %>%
  step_modeimpute(all_nominal()) %>%
  step_knnimpute(sunshine, evaporation, cloud3pm, cloud9am) %>%
  step_mutate(cloudchange = cloud3pm - cloud9am) %>%
  prep()

# saveRDS(rpart, "initial_recipe.RDS")
