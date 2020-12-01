# Cleaning and integrating Walkscore data:

# Basic Vision ==========
#Access walkscore data (ws)
#Filter it for nj
#Attach spatial data via census
#spatial join to municipality
#Write it

#Load Packages===== 
library(sf)
library(tidyverse)
library(tidylog)

#Read Data ====== 

#Municipality Spatial Data:
mun <- st_read("data_in_progress/mun_boundaries.geojson")
mun_simp <- mun%>%
  select(Place.Name)

#Shapefile because shapefile on box didn't have shx :()
bg_2013 <- st_read("data_raw/tl_2013_34_bg.shp")

#Walkscore Data from Box:
ws <- read.csv('data_raw/BGs_MSAs_174186_032013.csv') 

ws2 <- ws %>%
  mutate(state = str_sub(CBSA_NAME, -2)) %>%
  filter(state == "NJ") %>%
  filter(!str_detect(CBSA_NAME, "PA-NJ")) %>%
  mutate(GEOID = as.character(geoid2)) %>%
  select(GEOID, CBSA, CBSA_NAME, state, SSWS2USE, ED1_NO, ED1_PERC, ED2_NO, ED2_PERC) 

#Join walkscore and shp data together so that walkscore gets spatial data
ws_2012 <- left_join(ws2, bg_2013, by = "GEOID")

#Set WS CRS for spatial join:
ws_2012 <- st_transform(st_as_sf(ws_2012), 3424)

#Spatial Join to municipality Data:
ws_2012_mun <- st_join(st_as_sf(ws_2012), mun_simp)

#Group by municipality:
ws_mun <- ws_2012_mun %>%
  group_by(Place.Name) %>%
  summarise("med_walk_score" = median(SSWS2USE), 
            "mean_walk_scre" = mean(SSWS2USE),
            "sum_ed1" = sum(ED1_NO), 
            "sum_ed2" = sum(ED2_NO))



#Write:
st_write(ws_mun, "data_in_progress/walkscore_education_mun_2012.geojson")




