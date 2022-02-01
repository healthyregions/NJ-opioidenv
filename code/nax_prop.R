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
## NAX locations
## New Jersey Tracts / centroids
## new Jersey municipalities

### Read in Data

### Read in naloxone data
setwd("~/Documents/HEROP")
NAX <- read_csv("nj_naloxone_pharmacies_geocoded.csv")


# Remove observations with less than 90% match

NAX <- NAX[NAX$`Match Score` > 90,]


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

NAX_shp <- st_as_sf(NAX, coords = c("Longitude", "Latitude" ), crs = st_crs(nj_tract))



#setwd("~/Documents/HEROP")
#st_write(NAX_shp,"NAX_shp_test", driver = "ESRI Shapefile", append = TRUE)


crs(NAX_shp)


### Plot
tm_shape(nj_tract) +
  tm_borders() +
  tm_shape(NAX_shp) +
  tm_dots(col = "blue", size = 0.2)

### Transform CRS
nj_tract <- st_transform(nj_tract, 103105)
nj_municipal <- st_transform(nj_municipal, 103105)
NAX_shp <- st_transform(NAX_shp, 103105)

### Generate Tract Centroid
tract_centroid <- st_centroid(nj_tract)

tract_centroid <- st_transform(tract_centroid, 103105)

### Nearest Resource
nearest_NAX_indexes <- st_nearest_feature(tract_centroid, NAX_shp)

nearest_NAX <- NAX_shp[nearest_NAX_indexes,]

### calculate distance of nearest resource
distance_NAX <- st_distance(tract_centroid, nearest_NAX, by_element = TRUE)

###change units to miles
distance_NAX <- set_units(distance_NAX, "mi")

#merge data
distance_NAX_merged <- cbind(tract_centroid, distance_NAX)

### Read in crosswalk
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")
cw <- rename(cw, GEOID = TRACTID)
cw$GEOID <- as.numeric(cw$GEOID)

### merge crosswalk and distance matrix
distance_NAX_weight <- merge(distance_NAX_merged, cw, by = "GEOID")

### Weighted column
NAX_distances <- distance_NAX_weight %>%
  mutate(weighted_d = distance_NAX * prop_of_ct)

### Aggregate

## agg % of tracts closer than 10 miles

# create a variable for less than 10 miles (binary)
NAX_distances$lessthan10 <- ifelse(drop_units(NAX_distances$weighted_d) < 10, 1, 0)

# create a dummy variable that sums # of tracts
NAX_distances$all <- 1

# create two aggregated datasets
sub_10 <- aggregate(NAX_distances$lessthan10, by=list(SSN=NAX_distances$SSN), FUN=sum)
sub_10 <- rename(sub_10, num_less = x)

all <- aggregate(NAX_distances$all, by=list(SSN=NAX_distances$SSN), FUN=sum)
all <- rename(all, all = x)

#left merge

dummy_merge <- left_join(sub_10, all, by = "SSN")

#new column for num less / total

dummy_merge$prop_under_10mi <- dummy_merge$num_less / dummy_merge$all


# clean

final <- dummy_merge

final = subset(final, select = -c(num_less, all))



### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(final, "NAX_under10.csv", row.names = FALSE)


# save to master


### Merge to masters
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("working_master(abridged).csv")

master_updated <- merge(master, final, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "working_master(abridged).csv", row.names = FALSE) 





