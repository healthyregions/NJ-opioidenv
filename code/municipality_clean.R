#Import, Clean, Write Municipality Data


library(tidyverse)
library(sf)
library(rmapshaper)


#Read and some cleaning of municipal boundaries shapefile:
mun_boundaries <- st_read('Municipal_Boundaries_of_NJ.shp') %>%
  select(c("MUN", "MUN_TYPE", "GNIS_NAME", "GNIS", "SSN", "CENSUS2010":"POPDEN1980",
           "geometry")) %>% #Grab only relevant variables
  rename(Place.Name = MUN) %>%#rename column for join
  ms_simplify(keep = .25) 
mun_boundaries$Place.Name <- tolower(mun_boundaries$Place.Name)

#Write:
st_write(mun_boundaries, "mun_boundaries.geojson")