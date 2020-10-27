# Cleaning and integrating Walkscore data:

# Basic Vision ==========
#(1) filter only for NJ 
#(2) spatial join to municipality data 
#(3) group_by walkscore weighted by population and maybe just walkscore

#Load Packages===== 
library(sf)
library(tidyverse)
library(tidylog)

#Read Data ====== 

#Shapefile because shapefile on box didn't have shx :()
setwd("~/Documents/U_Chicago_Year_4/NJ-opioidenv/data_raw") #Again I am sorry
bg_2013 <- st_read("tl_2013_34_bg.shp")

#Walkscore Data from Box:
ws <- read.csv('BGs_MSAs_174186_032013.csv') %>%
  rename(GEOID = geoid2)
ws$GEOID <- as.character(ws$GEOID)

#Read in and join to pe2015
setwd("~/Documents/U_Chicago_Year_4/NJ-opioidenv/data_in_progress")
pe2015 <- st_read("physical_environment_2015.geojson")

#Join walkscore and shp data together so that walkscore gets shp
ws_2013 <- left_join(bg_2013, ws)
#NOTE HERE: there were 17 rows only in X; could be a bias that we return to later

#Cleaning ws ======
ws_2013 <- ws_2013 %>%
  select("GEOID", "CBSA", "CBSA_NAME", "POP", "SSWS2USE", "geometry") %>%
  st_transform(crs = 3424)

#Spatial Join ======
# Gives municipality data to ws_204
st_crs(ws_2013)
st_crs(pe2015)

ws_2013_mun <- st_join(ws_2013, pe2015["place_name"])
ws_2013_mun <- ws_2013_mun %>%
  mutate(pop_ws = POP * SSWS2USE)

mun_ws <- ws_2013_mun %>%
  group_by(place_name) %>%
  summarize(pop_ws = sum(pop_ws), pop = sum(POP)) %>%
  mutate(pop_weighted_ws = pop_ws/pop)

tm_shape(mun_ws) + tm_polygons(col = "pop_weighted_ws")




