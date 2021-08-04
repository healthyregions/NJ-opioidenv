
library(tidyverse)
library(sf)
library(units)
library(tmap)


### Read NJ municipalities

setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")

### Read ME
setwd("~/Box/BEOM UIC - Address-level Data/ME Spreadsheets/Final ME")

me_sf_try <- st_read("me_data_geocode_complete.csv", options=c("X_POSSIBLE_NAMES=Longitude","Y_POSSIBLE_NAMES=Latitude"), crs = 4326)

#ME <- read.csv("me_data_geocode_complete.csv")

#ME <- filter(ME, )

## ME as sf
#ME_sf <- st_as_sf(ME, coords = c("Longitude", "Latitude"), crs = 4326 )




### Transform CRS
#nj_municipal <- st_transform(nj_municipal, 4326)
#me_sf_try <- st_transform(ME_sf, ???)


#st_crs(nj_municipal)

#setwd("~/Documents/HEROP")
#st_write(ME_sf,"ME_sf_test", driver = "ESRI Shapefile", append = TRUE)

#nj_municipal= st_make_valid(nj_municipal)
#st_is_valid(nj_municipal)


# plot to see how they relate
ggplot() +
  geom_sf(data = nj_municipal) +
  geom_sf(data = me_sf_try) +
  theme_minimal()

tm_shape(nj_municipal) +
  tm_borders() +
  tm_shape(ME_sf) +
  tm_dots(col = "blue", size = 0.2)





####

pointsinpoly <- st_join(me_sf_try , nj_municipal, join = st_within)





