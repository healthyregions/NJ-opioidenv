#Import, Clean, Write Municipality Data


library(tidyverse)
library(sf)
library(rmapshaper)


#Read and some cleaning of municipal boundaries shapefile:
mun_boundaries <- st_read('data_raw/Municipal_Boundaries_of_NJ.shp') %>%
  select(c("MUN", "GNIS_NAME", "GNIS", "SSN", "SQ_MILES", "geometry")) %>% #Grab only relevant variables
  rename(Place.Name = MUN) %>%#rename column for join
  ms_simplify(keep = .25) 
mun_boundaries$Place.Name <- tolower(mun_boundaries$Place.Name)

#Write:
st_write(mun_boundaries, "data_in_progress/mun_boundaries.geojson")