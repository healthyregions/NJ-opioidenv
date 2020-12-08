#Joining Municipality Data:

library(sf)
library(tidyverse)
library(tidylog)

alc_mun <- read.csv("data_in_progress/alc_mun.csv")
bike_paths <- read.csv("data_in_progress/bike_paths_mun.csv")
pe <- read.csv("data_in_progress/physical_environment_2015.csv")
ws_ed <- read.csv("data_in_progress/walkscore_education_mun_2012.csv")




mun_master <- left_join(pe, ws_ed, by = c("Place.ID" = "SSN")) %>%
  left_join(bike_paths, by = c("Place.ID" = "SSN")) %>%
  left_join(alc_mun, by = c("Place.ID" = "SSN"))


