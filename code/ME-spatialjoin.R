setwd("~/Code/NJ-opioidenv/code")

library(sf)
library(tmap)

me <- read.csv("~/Downloads/me_data_geocode_complete.csv")
head(me)
dim(me) #7496

NJ <- st_read("~/Code/NJ-opioidenv/index_calc/NJMaster_finalindex5.geojson")
tm_shape(NJ) + tm_fill() 

st_crs(NJ)

NJ$geometry <- NJ$geometry %>%
  s2::s2_rebuild() %>%
  sf::st_as_sfc(FALSE)



me.sf <- st_as_sf(me, coords = c("Longitude","Latitude"), crs = 4326)


NJ.sf <- st_transform(NJ, 4326)

tm_shape(NJ) + tm_fill() 
  tm_shape(me.sf) + tm_dots()

me.2 <- st_join(me.sf, NJ.sf, join = st_within)
head(me.2)

