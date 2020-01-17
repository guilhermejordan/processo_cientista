library(dplyr)
library(recipes)
library(caret)
library(doSNOW)

source('r_functions/load_rain_dataset.R')
rain <- load_rain_dataset()

set.seed(42)
inTrain <- createDataPartition(rain$raintomorrow, p=0.05, list=FALSE)
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
          amountOfRain, date) %>%
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

xgb_grid <- expand.grid(nrounds = c(50, 75, 100),
                        max_depth = 4:7,
                        min_child_weight = 1,
                        subsample = 1,
                        gamma = 0,
                        colsample_bytree = c(0.3, 0.5, 0.8),
                        eta = .3)

reset.seed()
cl <- makeCluster(4, type = "SOCK")
registerDoSNOW(cl)
set.seed(42)
system.time(xgb <- train(raintomorrow ~ .,
                data = training_baked,
                method = "xgbTree",
                na.action = na.pass,
                tuneGrid = xgb_grid,
                trControl = train_control,
                metric = 'ROC'))
stopCluster(cl)


saveRDS(xgb, "modelling/xgb.RDS")
