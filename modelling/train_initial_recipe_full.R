library(dplyr)
library(recipes)

source('r_functions/load_rain_dataset.R')
rain <- load_rain_dataset()

rain_recipe <-
  recipe(raintomorrow ~ .,
         data = rain) %>%
  step_rm(amountOfRain, modelo_vigente) %>%
  step_mutate(
    tempamplitude = maxtemp - mintemp,
    tempchange = temp3pm - temp9am,
    humiditychange = humidity3pm - humidity9am,
    pressurechange = pressure3pm - pressure9am,
    precipitationchange = precipitation3pm - precipitation9am,
  ) %>%
  step_corr(all_numeric()) %>%
  step_medianimpute(all_numeric(),-sunshine,-evaporation,-cloud3pm,-cloud9am) %>%
  step_modeimpute(all_nominal()) %>%
  step_knnimpute(sunshine, evaporation, cloud3pm, cloud9am) %>%
  step_mutate(cloudchange = cloud3pm - cloud9am) %>%
  prep()

saveRDS(rain_recipe, "initial_recipe_full.RDS")
