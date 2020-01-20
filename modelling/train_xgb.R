# Script for fitting xgboost model

# Load packages
library(dplyr)
library(recipes)
library(caret)
library(doParallel)


# Load data
source('r_functions/load_rain_dataset.R')
rain <- load_rain_dataset()
cat('data loaded')


# Fit preprocessing recipe
rain_recipe <-
  recipe(raintomorrow ~ .,
         data = rain) %>%
  step_mutate(
    tempamplitude = maxtemp - mintemp,
    tempchange = temp3pm - temp9am,
    humiditychange = humidity3pm - humidity9am,
    pressurechange = pressure3pm - pressure9am,
    precipitationchange = precipitation3pm - precipitation9am,
    cloudchange = cloud3pm - cloud9am,
    month = lubridate::month(date),
  ) %>%
  step_rm(date, amountOfRain) %>%
  check_cols(all_predictors()) %>%
  prep()

cat('recipe trained')
#saveRDS(rain_recipe, "app/initial_recipe.RDS")

# Split train/test
set.seed(42)
inTrain <- createDataPartition(rain$raintomorrow, p = 0.75, list = FALSE)
training <- rain[inTrain, ]
testing <- rain[-inTrain, ]


# Apply preprocessing recipe
training_baked <- bake(rain_recipe, training)
testing_baked <- bake(rain_recipe, testing)

# Setup parallel processing
cl <- makePSOCKcluster(parallel::detectCores())
registerDoParallel(cl)

# Setup caret::trainControl
train_control <- trainControl(
  method = "none",
  classProbs = TRUE
)

# Fit xgboost model
cat('training start')
set.seed(42)
xgb <- train(
  raintomorrow ~ .,
  data = training_baked,
  method = "xgbTree",
  na.action = na.pass,
  tuneGrid = data.frame(
    nrounds = 1000,
    max_depth = 5,
    eta = 0.05,
    gamma = 0,
    colsample_bytree = 1,
    min_child_weight = 6,
    subsample = 0.85
  ),
  trControl = train_control,
  metric = "ROC"
)
stopCluster(cl)
#saveRDS(xgb, "app/xgb.RDS")
cat('training finished')

