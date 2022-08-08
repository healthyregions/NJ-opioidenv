

library(sf)
library(tmap)
library(units)
library(tidyverse)
library(dplyr)
library(raster)
library(rgdal)
library(sp)


##### License counts for just bars and liquor stores

## license Locations
setwd("~/Documents/HEROP")
license <- read.csv("bar_store_licenses.csv")


bars <- subset(license, is.bar == "1")

stores <- subset(license, is.store == "1")

both <- subset(license, is.bar == "1" & is.store == "1")

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

bars_shp <- st_as_sf(bars, coords = c("Longitude", "Latitude" ), crs = st_crs(nj_tract))

stores_shp <- st_as_sf(stores, coords = c("Longitude", "Latitude" ), crs = st_crs(nj_tract))

license_shp <- st_as_sf(license, coords = c("Longitude", "Latitude" ), crs = st_crs(nj_tract))

nj_municipal <- st_as_sf(nj_municipal, coords = c("Longitude", "Latitude" ), crs = st_crs(nj_tract))


bars_ls <- rbind(bars_shp, stores_shp)


#setwd("~/Documents/HEROP")
#st_write(,"", driver = "ESRI Shapefile", append = TRUE)


### Plot Bars
tm_shape(nj_municipal) +
  tm_borders() +
  tm_shape(bars_shp) +
  tm_dots(col = "blue", size = 0.1, alpha = 0.5)


### Plot Stores

tm_shape(nj_municipal) +
  tm_borders() +
  tm_shape(stores_shp) +
  tm_dots(col = "blue", size = 0.1, alpha = 0.5)




### Transform CRS
nj_tract <- st_transform(nj_tract, 3424)
nj_municipal <- st_transform(nj_municipal, 3424)
bars_ls <- st_transform(license_shp, 3424)

# Spatial Join
bar_ls_mun <- st_join(bars_ls, nj_municipal, join = st_within)

#count
bar_ls_mun_count<- as.data.frame(table(bar_ls_mun$SSN))

#rename
names(bar_ls_mun_count) <- c("SSN","bar_ls_mun_count")


#merge
bar_ls_count_new <- left_join(nj_municipal, bar_ls_mun_count, by="SSN", all = TRUE)

bar_ls_count_new$bar_ls_mun_count[is.na(bar_ls_count_new$bar_ls_mun_count)] <- 0


library(sf)
library(dplyr)

municipal_areas <- nj_municipal %>% 
  mutate(mun_area = st_area(nj_municipal$geometry))

areas <- drop_units(municipal_areas$mun_area)

municipal_areas$mun_area = areas

municipal_areas$area_km2 = municipal_areas$mun_area / 1000000


bar_ls_count_new$bars_ls_per_km2 = bar_ls_count_new$bar_ls_mun_count / municipal_areas$area_km2

bar_ls_count_new$bars_ls_per_km2[is.na(bar_ls_count_new$bars_ls_per_km2)] <- 0

#get variables of interest

sub <- c("SSN", "MUN", "bars_ls_per_km2")

bar_ls_per_area <- bar_ls_count_new[sub]

bar_ls_per_area$geometry = NULL


##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(bar_ls_per_area, "bars_ls_per_area.csv", row.names = FALSE)




#___________________________________________________________

###Merge to master

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
bar_ls_merge <- read.csv("bars_ls_per_area.csv")
abridged <- read.csv("master(abridged).csv")
expanded <- read.csv("master(expanded).csv")


abridged_updated <- merge(abridged, bar_ls_merge, by = "SSN")

expanded_updated <- merge(expanded, bar_ls_merge, by = "SSN")

#remove old
abridged_updated$ls_per_sqft = NULL
abridged$MUN = NULL

expanded_updated$count_ls = NULL
expanded_updated$count_bars = NULL
expanded_updated$bars_per_sqft = NULL
expanded_updated$bars_per_pop = NULL
expanded_updated$ls_per_sqft = NULL
expanded_updated$ls_per_pop = NULL
expanded_updated$bars_ls_per_sqft = NULL
expanded_updated$bars_ls_per_pop = NULL
expanded$MUN = NULL

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(abridged_updated, "master(abridged).csv", row.names = FALSE)


write.csv(expanded_updated, "master(expanded).csv", row.names = FALSE)







