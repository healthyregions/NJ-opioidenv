library(sf)
library(tmap)
library(units)
library(tidyverse)
library(dplyr)
library(arsenal)

setwd("~/Desktop/Harris/Opioid - RA")

syringe <- read_sf("NJ syringe exchange/nj_syringe.shp")
nj_tract <- read_sf("NJ census tracts/tl_2018_34_tract.shp")
nj_municipal <- read_sf("NJ municipal/Municipal_Boundaries_of_NJ.shp")

# plot
tm_shape(nj_tract) +
  tm_borders() +
  tm_shape(syringe) +
  tm_dots(col = "blue", size = 0.2)

#transform CRS
nj_tract <- st_transform(nj_tract, 103105)
syringe <- st_transform(syringe, 103105)
nj_municipal <- st_transform(nj_municipal, 103105)

# centroid
tract_centroid <- st_centroid(nj_tract)

#calculate nearest resource
nearest_syringe_indexes <- st_nearest_feature(tract_centroid, syringe)

nearest_syringe <- syringe[nearest_syringe_indexes,]

#calculate distance of nearest resource
distance_syringe <- st_distance(tract_centroid, nearest_syringe, by_element = TRUE)
distance_naloxone

#change units to miles
distance_syringe <- set_units(distance_syringe, "mi")

#merge data
distance_syringe_merged <- cbind(tract_centroid, distance_syringe)

#load crosswalk
cw_areal_interpolation_1_ <- read_csv("cw_areal_interpolation (1).csv")
crosswalk <- cw_areal_interpolation_1_
crosswalk <- crosswalk %>%
  rename(GEOID = "TRACTID")

# merge crosswalk and distance matrix
distance_syringe_weight <- merge(distance_syringe_merged, crosswalk, by.x = "GEOID", by.y = "GEOID")

# create weighted column

distance_syringe_weight <- distance_syringe_weight %>%
  mutate(weighted_d = distance_syringe * prop_of_ct)

# aggregate

aggregated_syringe <- distance_syringe_weight %>%
  group_by(SSN) %>%
  summarise(average_distance = mean(weighted_d))

aggregated_syringe <- aggregated_syringe %>%
  st_drop_geometry()

write_csv(aggregated_syringe, "syringe_distance.csv")
