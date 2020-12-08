#Joining Municipality Data:

library(sf)
library(tidyverse)
library(tidylog)

alc_mun <- st_read("data_in_progress/alc_mun.geojson")
bike_paths <- st_read("data_in_progress/bike_paths_mun.geojson")
pe <- st_read("data_in_progress/physical_environment_2015.geojson")
ws_ed <- st_read("data_in_progress/walkscore_education_mun_2012.geojson")


#Convert to df:
convert_to_df <- function(df) {
  df <- df %>%
    as.data.frame() %>%
    select(-geometry)
}

alc_mun <- convert_to_df(alc_mun) 
bike_paths <- convert_to_df(bike_paths)
ws_ed <- convert_to_df(ws_ed)

mun_master <- left_join(pe, ws_ed, by = "Place.Name")


mun_master2 <- left_join(mun_master, bike_paths, by = "Place.Name")
