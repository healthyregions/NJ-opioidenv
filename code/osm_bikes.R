#Bike Data: 

#load packages
library(tidyverse)
library(tidylog)
library(osmdata)
library(sf)
library(tmap)

# Step 1: Reading =====
#Read from OSM
bb_nj <- getbb ('New Jersey', format_out = 'polygon')
bike_designated_query <- opq(bb_nj) %>% #This is the overpass_query object which becomes the space designated in bb from the pipe
  add_osm_feature(key = 'bicycle', value = 'designated') %>%
  osmdata_sf() %>%
  trim_osmdata(bb_nj)


bike_cycleway_query <- opq(bb_nj) %>% #This is the overpass_query object which becomes the space designated in bb from the pipe
  add_osm_feature(key = 'highway', value = 'cycleway') %>%
  osmdata_sf() %>%
  trim_osmdata(bb_nj)

bike_path_query <- opq(bb_nj) %>% #This is the overpass_query object which becomes the space designated in bb from the pipe
  add_osm_feature(key = 'highway', value = 'path') %>%
  osmdata_sf() %>%
  trim_osmdata(bb_nj)

bike_footpath_query <- opq(bb_nj) %>% #This is the overpass_query object which becomes the space designated in bb from the pipe
  add_osm_feature(key = 'highway', value = 'footpath') %>%
  osmdata_sf() %>%
  trim_osmdata(bb_nj)

#Step 2: Combining Query Data =======

#Two sets of data:
#Vision: first list includes large group of what could be bike lanes. 
#Others also bike get more bike lanes but also a lot of non-motorized paths
nj_bikes_and_paths <- c(bike_designated_query, bike_cycleway_query, bike_path_query, bike_footpath_query) 
nj_strong_bikes <-c(bike_designated_query, bike_cycleway_query)

nj_bikes_and_paths_lines <-nj_bikes_and_paths$osm_lines
nj_bikes_lines <- nj_strong_bikes$osm_lines

#Step 3: Compute Path Length ======= 

#Convert to same ESPG as Municipalities:
nj_bikes_and_paths_lines <- st_transform(nj_bikes_and_paths_lines, 3424)
nj_bikes_lines <- st_transform(nj_bikes_lines, 3424)

#Compute distance of each set of data (to use in ratio with total area):
nj_bikes_lines$length <- st_length(nj_bikes_lines)
nj_bikes_and_paths_lines$length <- st_length(nj_bikes_and_paths_lines)


#Step 4: Municipality Data Manipulation =======


#Read in municipality spatial data:
mun <- st_read("data_in_progress/mun_boundaries.geojson")
mun_area <- mun %>%
  as.data.frame() %>%
  select(SSN, SQ_MILES) 

#Convert to Centroids:
nj_bikes_centroids <- st_centroid(nj_bikes_lines)
nj_bikes_and_paths_centroids <-st_centroid(nj_bikes_and_paths_lines)

#Spatial Join of municipalities
nj_bikes_centroids <- st_join(nj_bikes_centroids, mun["SSN"])
nj_bikes_and_paths_centroids <- st_join(nj_bikes_and_paths_centroids, mun["SSN"])



#Step 5: Compute distance/area ratio ======

#Group-by Municipality:
bikes_mun <- nj_bikes_centroids %>%
  group_by(SSN) %>%
  summarise("length_bike" = sum(length)) #all SQ_MILES are same, so this just returns same val

bikes_paths_mun <- nj_bikes_and_paths_centroids %>%
  group_by(SSN) %>%
  summarise("length_path" = sum(length)) 

bikes_mun <- left_join(bikes_mun, mun_area, by = "SSN")
bikes_paths_mun <- left_join(bikes_paths_mun, mun_area, by ="SSN")

#Compute ratio of distance/area (ft/sq mile):
bikes_paths_mun <- as.data.frame(bikes_paths_mun) %>%
  mutate(bike_path_ft_p_mile = length_path / SQ_MILES) %>%
  select(SSN, bike_path_ft_p_mile)
  
bikes_mun <- as.data.frame(bikes_mun) %>%
  mutate(bikes_ft_p_mile = length_bike / SQ_MILES) %>%
  select(SSN, bikes_ft_p_mile)

#Join files
bike_paths_mun <- left_join(bikes_paths_mun, bikes_mun) %>%
  filter(SSN != 'NA')

#Step 6: Write data =====
#Write file :)
st_write(bike_paths_mun, "data_in_progress/bike_paths_mun.csv")



