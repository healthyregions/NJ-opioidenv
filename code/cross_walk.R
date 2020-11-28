#Creating Crosswalk

#Load packages
library(tidyverse)
library(tidylog)
library(sf)
library(tmap)

#Import spatial data: 
ct <- st_read("data_raw/Census2010Tr2012/Govt_TIGER2012_tract2010.shp") %>%
  select(TRACTID)

mun <- st_read("data_in_progress/mun_boundaries.geojson") %>%
  select(Place.Name)

#Convert to ESPG 3424 and add sq ft: 
geography_setup <- function(df) {
  st_transform(df, 3424) %>%
  mutate(area = st_area(df))
           }

ct <- geography_setup(ct) %>%
  rename(ct_area_sq_ft = area)
mun <- geography_setup(mun) %>%
  rename(mun_area_sq_ft = area)


#Run actual crosswalk
areal_weights <- st_intersection(st_make_valid(mun), ct) %>% #Note st_make_valid from link below
  mutate(area = st_area(geometry)) %>%
  select(Place.Name, TRACTID, area) %>%
  group_by(TRACTID) %>%
  mutate(prop_of_ct = area / sum(area))

#Demonstrative example:
ex <- areal_weights %>%
  filter(TRACTID == "34001010200")
#~96% in Abescon City, ~3% in Atlantic City, and ~1% in Galloway TWP
#Process to use(I think):
#(1) Import data at tract level
#(2) Join data to this file by tract  
#(3) for column X create new column X * prop_of_tract then group_by Place.Name and summarize(sum(X*prop_of_tract))




#Links of use:
# Guide used: https://sixtysixwards.com/home/crosswalk-tutorial/
# st_make_valid suggestion from: https://github.com/r-spatial/sf/issues/347

#Tests  on st_intersection ====
a<- st_polygon(list(cbind(c(0, 10, 10, 5, 5, 10, 10, 0, 0), c(0, 0, 2, 2, 8, 8, 10, 10, 0))))
b<- st_polygon(lst(cbind(c(7, 9, 9, 7, 7), c(1, 1, 9, 9, 1))))
c<- st_polygon(lst(cbind(c(2, 2, 3, 3, 2), c(5, 6, 6, 5, 5))))

plot(a)
plot(b, col = "yellow", add = T)
plot(c, col = "red", add = T)

i <- st_intersection(a, b)
plot(i, add= T, col = "green")
j <- st_intersection(a, c)
plot(j, add = T, col = "purple")
