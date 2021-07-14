library(sf)
library(tmap)
library(units)
library(tidyverse)
library(dplyr)
library(arsenal)

setwd("~/Desktop/Harris/Opioid - RA")

naloxone <- read_sf("NJ naloxone/nj_naloxone.shp")
nj_tract <- read_sf("NJ census tracts/tl_2018_34_tract.shp")
nj_municipal <- read_sf("NJ municipal/Municipal_Boundaries_of_NJ.shp")

# plot
tm_shape(nj_tract) +
  tm_borders() +
  tm_shape(naloxone) +
  tm_dots(col = "blue", size = 0.2)

#transform CRS
nj_tract <- st_transform(nj_tract, 103105)
naloxone <- st_transform(naloxone, 103105)
nj_municipal <- st_transform(nj_municipal, 103105)

# centroid
tract_centroid <- st_centroid(nj_tract)

#calculate nearest resource
nearest_naloxone_indexes <- st_nearest_feature(tract_centroid, naloxone)

nearest_naloxone <- naloxone[nearest_naloxone_indexes,]

#calculate distance of nearest resource
distance_naloxone <- st_distance(tract_centroid, nearest_naloxone, by_element = TRUE)
distance_naloxone

#change units to miles
distance_naloxone <- set_units(distance_naloxone, "mi")

#merge data
distance_naloxone_merged <- cbind(tract_centroid, distance_naloxone)

#load crosswalk
cw_areal_interpolation_1_ <- read_csv("cw_areal_interpolation (1).csv")
crosswalk <- cw_areal_interpolation_1_
crosswalk <- crosswalk %>%
  rename(GEOID = "TRACTID")

# merge crosswalk and distance matrix
distance_naloxone_weight <- merge(distance_naloxone_merged, crosswalk, by.x = "GEOID", by.y = "GEOID")

# create weighted column

distance_naloxone_weight <- distance_naloxone_weight %>%
  mutate(weighted_d = distance_naloxone * prop_of_ct)

# aggregate

aggregated_naloxone <- distance_naloxone_weight %>%
  group_by(SSN) %>%
  summarise(average_distance = mean(weighted_d))

aggregated_naloxone <- aggregated_naloxone %>%
  st_drop_geometry()

# write 

write_csv(aggregated_naloxone, "naloxone_distance.csv")

