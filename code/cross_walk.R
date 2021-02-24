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
  select(Place.Name, SSN, POP2010)

#bgpop <- st_read("data_in_progress/nj_bg_pop_2016.geojson")


#Spatial Data Configuration ====== 
#Convert to ESPG 3424 and add sq ft: 
geography_setup <- function(df) {
  st_transform(df, 3424) %>%
  mutate(area = st_area(df))
           }

ct <- geography_setup(ct) %>%
  rename(ct_area_sq_ft = area)
mun <- geography_setup(mun) %>%
  rename(mun_area_sq_ft = area)

bgpop <- bgpop %>%
  st_transform(3424) %>%
  st_centroid()

#Create new geometries that constitute either ct or each component of ct that is divided by municipality boundary
ct_div <- st_intersection(st_make_valid(mun), ct) %>% #Note st_make_valid from link below
  mutate(area = st_area(geometry)) %>%
  select(Place.Name, SSN, TRACTID, area) %>%
  group_by(TRACTID) %>%
  mutate(prop_of_ct = area / sum(area)) #%>%
  #mutate(prop_of_mun = )
  #as.data.frame() %>%
  #select(Place.Name, SSN, TRACTID, prop_of_ct)
#Comment: the above prop_of_ct is, as described, the proportion of each census tract in each row
#Below I bring back in the area of the municipality to compute what percent area each municipality is

#Get df just of municipalities and their areas:
#mun_area <- mun %>%
#  as.data.frame() %>%
#  select(SSN, mun_area_sq_ft)


#Areal interpolation======
#Compute the % each polygon of ct_div is of the municipality in which they reside
areal_interpolation <- ct_div %>%
  select(Place.Name, SSN, TRACTID, prop_of_ct) %>%  # #grab only columns desired 
  mutate(TRACTID = as.character(TRACTID))




#Population Weighted Crosswalk ======

#Give population Data to each fragment at small (block group) spatial scale:
#ct_div_pop <- st_join(ct_div, bgpop["pop2016"]) %>%
#  #filter(pop2016 > 0) %>% #This removes all areas where populations are 0/NA which makes theoretical sense
#  rename(ct_div_pop = pop2016) %>%
#  mutate(ct_div_pop = replace_na(ct_div_pop, 0)) %>%
#  group_by(SSN) %>% #Begins computation for total pop for mun 
#  mutate(pop_mun = sum(ct_div_pop, na.rm = TRUE)) %>% #computes total pop for mun
#  mutate(pct_of_mun_pop = ct_div_pop /pop_mun) %>% #Assign area a percentage of the municipality 
                                                    #it is in based on its pop relative to the total pop
#  as.data.frame() %>%
#  select(c(Place.Name, SSN, TRACTID, pct_of_mun_pop)) 
  







#Write data ====

st_write(areal_interpolation, "data_final/cw_areal_interpolation.csv")
#st_write(ct_div_pop, "data_final/cw_pop_weight.csv") not complete



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
