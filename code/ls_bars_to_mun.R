#Liquor Stores to Municipality
#Gabe Morrison
#Goal is to aggregate liquor store point data to municipality with a variety of methods
#and to build off of Olina's work aggregating to the tract

library(tidyverse)
library(tidylog)
library(sf)
library(tmap)

#Read liquor stores:
#note: I am relatively sure that these are aggregated to the census tract- will sum and us ls/bar_count
ls <- st_read("data_raw/nj_liquorstores_summary.gpkg")
bars <- st_read("data_raw/nj_bars_summary.gpkg")

#Read municipality data:
mun <- st_read("data_in_progress/mun_boundaries.geojson")
mun_simp <- mun["Place.Name"]

#Set Same crs:
mun_simp <- st_transform(mun_simp, 3424)
ls <- st_transform(ls, 3424)
bars <- st_transform(bars, 3424)


#Container Method: 
#Goal is to get simple counts of liquor store per municipality:
ls_mun <- st_join(ls, mun_simp["Place.Name"])
bars_mun <- st_join(bars, mun_simp["Place.Name"])

#Bars:
bars_mun_sum <- bars_mun %>%
  group_by(Place.Name) %>%
  summarize("count_bars" = sum(bars_count))

#Liquor stores:
ls_mun_sum <- ls_mun %>%
  group_by(Place.Name) %>%
  summarize("count_ls" = sum(ls_count))

alc_mun <- left_join(bars_mun_sum, as.data.frame(ls_mun_sum)) %>%
  st_as_sf()

#Temporary until we get better pop data:
#Computes total counts above as well as density per area and per population of both
#Liquor stores and bars (and both combined!)
mun_pop <- as.data.frame(mun) %>%
  select(Place.Name, POP2010, SQ_MILES)
alc_mun <- left_join(alc_mun, mun_pop, by = "Place.Name") 
alc_mun <- alc_mun %>%
  mutate(bar_per_sq_mile = count_bars / SQ_MILES) %>%
  mutate(ls_per_sq_mile = count_ls / SQ_MILES) %>%
  mutate(bar_per_pop = count_bars / POP2010) %>%
  mutate(ls_per_pop = count_ls / POP2010) %>%
  mutate(bar_ls_per_sq_mile = (count_bars + count_ls) / SQ_MILES) %>%
  mutate(bar_ls_per_pop = (count_bars + count_ls) / SQ_MILES)

#write:
alc_mun <- st_as_sf(alc_mun)
st_write(alc_mun, "data_in_progress/alc_mun.geojson")

fun_map <- tm_shape(alc_mun) +tm_fill(col = "bar_ls_per_pop")
fun_map
