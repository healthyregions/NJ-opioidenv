

#### New Jersey Liquor Licenses 



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

## license Locations
setwd("~/Documents/HEROP")
license <- read.csv("liquor_license_1631201101_geocoded.csv")

#merge with main file
library(readxl)

setwd("~/Documents/HEROP")

license_names <- read_excel("Retail_Licensee (1).xlsx")

license_full <- merge(license, license_names, by.x = "ID", by.y = 'License Number')

##Save
#setwd("~/Documents/HEROP")

write.csv(license_full, "bar_store_licenses.csv", append = TRUE)

# Remove observations with less than 90% match

license_full <- license_full[license_full$Match.Score > 90,]


## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")

nj_municipal <- st_make_valid(nj_municipal)

## New Jersey Tracts
setwd("~/Documents/HEROP/tl_2018_34_tract")
nj_tract <- read_sf("tl_2018_34_tract.shp")

crs(nj_tract)


### Convert csv to shp
nj_CRS <- st_crs(nj_municipal)

class(nj_CRS)

license_shp <- st_as_sf(license_full, coords = c("Longitude", "Latitude" ), crs = st_crs(nj_tract))



#setwd("~/Documents/HEROP")
#st_write(SUT_shp,"SUT_shp_test", driver = "ESRI Shapefile", append = TRUE)


crs(SUT_shp)


### Plot
tm_shape(nj_municipal) +
  tm_borders() +
  tm_shape(license_shp) +
  tm_dots(col = "blue", size = 0.1, alpha = 0.5)

### Transform CRS
nj_tract <- st_transform(nj_tract, 103105)
nj_municipal <- st_transform(nj_municipal, 103105)
license_shp <- st_transform(license_shp, 103105)

# Spatial Join
license_mun <- st_join(license_shp, nj_municipal, join = st_within)

#count
license_count<- as.data.frame(table(license_mun$SSN))

#rename
names(license_count) <- c("SSN","license_count")


#merge
license_count_new <- left_join(nj_municipal, license_count, by="SSN", all = TRUE)

license_count_new$license_count[is.na(license_count_new$license_count)] <- 0


library(sf)
library(dplyr)

municipal_areas <- nj_municipal %>% 
  mutate(mun_area = st_area(nj_municipal$geometry))

areas <- drop_units(municipal_areas$mun_area)

municipal_areas$mun_area = areas

municipal_areas$area_km2 = municipal_areas$mun_area / 1000000


license_count_new$new_ls = license_count_new$license_count / municipal_areas$area_km2

license_count_new$new_ls[is.na(license_count_new$new_ls)] <- 0



## Old areas
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("master(abridged).csv")


license_count_new$old_ls <- master$ls_per_sqft

##Save
setwd("~/Documents/HEROP")

st_write(license_count_new, "license_counts.shp", append = TRUE)




