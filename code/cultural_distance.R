library(sf)
library(tmap)
library(units)
library(tidyverse)
library(dplyr)
library(arsenal)

setwd("~/Desktop/Harris/Opioid - RA")

# load files
cultural_center <- read_sf("NJ cultural/nj_cultural.shp")
museum <- read_sf("NJ museums/nj_museums.shp")
art <- read_sf("NJ art galleries/nj_art_galleries.shp")
cultural <- rbind(cultural_center, museum, art)
nj_tract <- read_sf("NJ census tracts/tl_2018_34_tract.shp")
nj_municipal <- read_sf("NJ municipal/Municipal_Boundaries_of_NJ.shp")

# plot
tm_shape(nj_tract) +
  tm_borders() +
  tm_shape(cultural) +
  tm_dots(col = "blue", size = 0.2)

#transform CRS
nj_tract <- st_transform(nj_tract, 103105)
cultural <- st_transform(cultural, 103105)
nj_municipal <- st_transform(nj_municipal, 103105)

# centroid
tract_centroid <- st_centroid(nj_tract)

#calculate nearest resource
nearest_cultural_indexes <- st_nearest_feature(tract_centroid, cultural)

nearest_cultural <- cultural[nearest_cultural_indexes,]

#calculate distance of nearest resource
distance_cultural <- st_distance(tract_centroid, nearest_cultural, by_element = TRUE)
distance_cultural

#change units to miles
distance_cultural <- set_units(distance_cultural, "mi")

#merge data
distance_cultural_merged <- cbind(tract_centroid, distance_cultural)

#load crosswalk
cw_areal_interpolation_1_ <- read_csv("cw_areal_interpolation (1).csv")
crosswalk <- cw_areal_interpolation_1_
crosswalk <- crosswalk %>%
  rename(GEOID = "TRACTID")

# merge crosswalk and distance matrix
distance_cultural_weight <- merge(distance_cultural_merged, crosswalk, by.x = "GEOID", by.y = "GEOID")

# create weighted column

distance_cultural_weight <- distance_cultural_weight %>%
  mutate(weighted_d = distance_cultural * prop_of_ct)

# aggregate

aggregated_cultural <- distance_cultural_weight %>%
  group_by(SSN) %>%
  summarise(average_distance = mean(weighted_d))

aggregated_cultural <- aggregated_cultural %>%
  st_drop_geometry()

write_csv(aggregated_cultural, "cultural_distance.csv")

