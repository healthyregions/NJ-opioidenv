# Cleaning and integrating Walkscore data:

# Basic Vision ==========
#Access walkscore data (ws)
#Filter it for nj
#Attach spatial data via census
#Write it

#Load Packages===== 
library(sf)
library(tidyverse)
library(tidylog)

#Read Data ====== 

#Shapefile because shapefile on box didn't have shx :()
setwd("~/Documents/U_Chicago_Year_4/NJ-opioidenv/data_raw") #Again I am sorry
bg_2013 <- st_read("tl_2013_34_bg.shp")

#Walkscore Data from Box:
ws <- read.csv('BGs_MSAs_174186_032013.csv') 

ws2 <- ws %>%
  mutate(state = str_sub(CBSA_NAME, -2)) %>%
  filter(state == "NJ") %>%
  filter(!str_detect(CBSA_NAME, "PA-NJ")) %>%
  mutate(GEOID = as.character(geoid2)) %>%
  select(GEOID, CBSA, CBSA_NAME, state, SSWS2USE, ED1_NO, ED1_PERC, ED2_NO, ED2_PERC) 

#Join walkscore and shp data together so that walkscore gets spatial data
ws_2013 <- left_join(ws2, bg_2013, by = "GEOID")

#Write:
st_write(ws_2013, "walkscore_education_bg_2013.geojson")





#Cleaning ws ======
ws_2013 <- ws_2013 %>%
  select("GEOID", "CBSA", "CBSA_NAME", "POP", "SSWS2USE", "geometry") %>%
  st_transform(crs = 3424)





#Read in and join to pe2015
setwd("~/Documents/U_Chicago_Year_4/NJ-opioidenv/data_in_progress")
pe2015 <- st_read("physical_environment_2015.geojson")



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




