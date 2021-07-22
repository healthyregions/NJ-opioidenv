
#### Aggregate Substance Use Treatment Acces


library(sf)
library(tmap)
library(units)
library(tidyverse)
library(dplyr)
library(raster)
library(rgdal)
library(sp)


### Data I want:
## SUT locations
## New Jersey Tracts / centroids
## new Jersey municipalities

### Read in Data

## SUT Locations
setwd("~/Documents/HEROP")
SUT <- read.csv("SUT_geocoded.csv")

# Remove observations with less than 90% match

SUT <- SUT[SUT$Match.Score > 90,]


## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")

## New Jersey Tracts
setwd("~/Documents/HEROP/tl_2018_34_tract")
nj_tract <- read_sf("tl_2018_34_tract.shp")

crs(nj_tract)


### Convert csv to shp
nj_CRS <- st_crs(nj_municipal)

class(nj_CRS)

SUT_shp <- st_as_sf(SUT, coords = c("Longitude", "Latitude" ), crs = st_crs(nj_tract))



#setwd("~/Documents/HEROP")
#st_write(SUT_shp,"SUT_shp_test", driver = "ESRI Shapefile", append = TRUE)


crs(SUT_shp)


### Plot
tm_shape(nj_tract) +
  tm_borders() +
  tm_shape(SUT_shp) +
  tm_dots(col = "blue", size = 0.2)

### Transform CRS
nj_tract <- st_transform(nj_tract, 103105)
nj_municipal <- st_transform(nj_municipal, 103105)
SUT_shp <- st_transform(SUT_shp, 103105)

### Generate Tract Centroid
tract_centroid <- st_centroid(nj_tract)

tract_centroid <- st_transform(tract_centroid, 103105)

### Nearest Resource
nearest_SUT_indexes <- st_nearest_feature(tract_centroid, SUT_shp)

nearest_SUT <- SUT_shp[nearest_SUT_indexes,]

### calculate distance of nearest resource
distance_SUT <- st_distance(tract_centroid, nearest_SUT, by_element = TRUE)

###change units to miles
distance_SUT <- set_units(distance_SUT, "mi")

#merge data
distance_SUT_merged <- cbind(tract_centroid, distance_SUT)

### Read in crosswalk
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")
cw <- rename(cw, GEOID = TRACTID)

### merge crosswalk and distance matrix
distance_SUT_weight <- merge(distance_SUT_merged, cw, by.x = "GEOID", by.y = "GEOID")

### Weighted column
SUT_distances <- distance_SUT_weight %>%
  mutate(weighted_d = distance_SUT * prop_of_ct)

### Aggregate

## avg min distance
mindist_mun <- aggregate(SUT_distances$weighted_d, by=list(SSN=SUT_distances$SSN), FUN=mean)
mindist_mun <- rename(mindist_mun, avg_min_dist = x)
mindist_mun <- drop_units(mindist_mun)

## agg % of tracts closer than 10 miles

# create a variable for less than 10 miles (binary)
SUT_distances$lessthan10 <- ifelse(drop_units(SUT_distances$weighted_d) < 10, 1, 0)

# create a dummy variable that sums # of tracts
SUT_distances$all <- 1

# create two aggregated datasets
sub_10 <- aggregate(SUT_distances$lessthan10, by=list(SSN=SUT_distances$SSN), FUN=sum)
sub_10 <- rename(sub_10, num_less = x)

all <- aggregate(SUT_distances$all, by=list(SSN=SUT_distances$SSN), FUN=sum)
all <- rename(all, all = x)

#left merge

dummy_merge <- left_join(sub_10, all, by = "SSN")

#new column for num less / total

dummy_merge$prop_under_10mi <- dummy_merge$num_less / dummy_merge$all


# left merge with avg min dist

final <- left_join(mindist_mun, dummy_merge, by = "SSN")

final = subset(final, select = -c(num_less, all))

subset2  <- c("SSN", "avg_min_dist", "prop_under_10mi")

final <- final[subset2]


### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(final, "SUT_distance.csv", row.names = FALSE)

