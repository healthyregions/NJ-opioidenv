#Census Tract Master:

library(tidyverse)
library(tidylog)
library(sf)

usps2020 <- read.csv("data_raw/usps_vac_092020.csv")
usps2020$GEOID <- as.character(usps2020$geoid)

rd <- read.csv("data_in_progress/residential_data.csv")
rd$GEOID <- as.character(rd$GEOID)

ct_master <- left_join(rd, usps2020)


tract<- left_join(tract, ct_master)
