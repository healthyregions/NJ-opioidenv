# load libraries

library(tidyverse)
library(dplyr)
library(sf)
library(tmap)
library(tidygeocoder)
library(stringr)
library(units)
library(arsenal)


# load adult education 

setwd("~/Desktop/Harris/Opioid - RA")
schools <- read_csv("NJ adult education/Adult Education Programs.csv")
nj_tract <- read_sf("NJ census tracts/tl_2018_34_tract.shp")
nj_municipal <- read_sf("NJ municipal/Municipal_Boundaries_of_NJ.shp")

schooltype_ct <- schools %>%
  group_by(SCHOOLTYPE) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

adult_ed <- schools %>%
  filter(SCHOOLTYPE == "ADULT EDUCATION SCHOOL")

# clean

adult_ed$ADDRESS1 <- gsub("2000 85Th Street", "2000 85th Street", 
                          adult_ed$ADDRESS1)

adult_ed$ZIP <- gsub("07047-4715", "7047", 
                     adult_ed$ZIP)

adult_ed$ZIP <- str_pad(adult_ed$ZIP, width=5, side="left", pad="0")

adult_ed <- adult_ed %>%
  select(DIST_NAME, ADDRESS1, CITY, STATE, ZIP)

# prepare input

str(adult_ed)

adult_ed$fullAdd <- paste(as.character(adult_ed$ADDRESS1), 
                                  as.character(adult_ed$CITY),
                                  as.character(adult_ed$STATE), 
                                  as.character(adult_ed$ZIP))
head(adult_ed)

# geocode

geoCodedAdultEd <- adult_ed %>% 
  geocode(address = 'fullAdd', 
          lat = latitude, long = longitude, method = 'cascade')

# enable points

AdultEdSf <- st_as_sf(geoCodedAdultEd, 
                        coords = c("longitude", "latitude"),
                        crs = 4326)
head(data.frame(AdultEdSf))

# save

write_sf(AdultEdSf, "adult_ed.shp")

# read in adult ed

adult_ed <- read_sf("NJ adult education/adult_ed.shp")

# plot
tm_shape(nj_tract) +
  tm_borders() +
  tm_shape(adult_ed) +
  tm_dots(col = "blue", size = 0.2)

#transform CRS
nj_tract <- st_transform(nj_tract, 103105)
adult_ed <- st_transform(adult_ed, 103105)
nj_municipal <- st_transform(nj_municipal, 103105)

# centroid
tract_centroid <- st_centroid(nj_tract)

#calculate nearest resource
nearest_adult_ed_indexes <- st_nearest_feature(tract_centroid, adult_ed)

nearest_adult_ed <- adult_ed[nearest_adult_ed_indexes,]

#calculate distance of nearest resource
distance_adult_ed <- st_distance(tract_centroid, nearest_adult_ed, by_element = TRUE)
distance_adult_ed

#change units to miles
distance_adult_ed <- set_units(distance_adult_ed, "mi")

#merge data
distance_adult_ed_merged <- cbind(tract_centroid, distance_adult_ed)

#load crosswalk
cw_areal_interpolation_1_ <- read_csv("cw_areal_interpolation (1).csv")
crosswalk <- cw_areal_interpolation_1_
crosswalk <- crosswalk %>%
  rename(GEOID = "TRACTID")

# merge crosswalk and distance matrix
distance_adult_ed_weight <- merge(distance_adult_ed_merged, crosswalk, by.x = "GEOID", by.y = "GEOID")

# create weighted column

distance_adult_ed_weight <- distance_adult_ed_weight %>%
  mutate(weighted_d = distance_adult_ed * prop_of_ct)

# aggregate

aggregated_adult_ed <- distance_adult_ed_weight %>%
  group_by(SSN) %>%
  summarise(average_distance = mean(weighted_d))

aggregated_adult_ed <- aggregated_adult_ed %>%
  st_drop_geometry()

adult_ed_distance <- aggregated_adult_ed %>%
  rename(average_d_adultEd = "average_distance")

write_csv(adult_ed_distance, "adult_ed_distance.csv")