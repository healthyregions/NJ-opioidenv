#Liquor Stores to Municipality
#Gabe Morrison
#Goal is to aggregate liquor store point data to municipality with a variety of methods
#and to build off of Olina's work aggregating to the tract

library(tidyverse)
library(tidylog)
library(sf)
library(tmap)

#Read Data:
ls_raw <- st_read("data_raw/nj_liquorstores_raw.gpkg")
bars_raw <- st_read("data_raw/nj_bars_raw.gpkg")

#Read municipality data:
mun <- st_read("data_in_progress/mun_boundaries.geojson")
mun_simp <- mun %>%
  st_transform(3424) %>%
  select(SSN, SQ_MILES)

#Set Up Geography:
set_up <- function(df){
  df <- df %>%
    select(osm_id, name) %>%
    st_transform(3424) %>%
    st_join(mun_simp["SSN"]) %>%
    mutate(ones = 1) %>%
    as.data.frame() %>%
    select(-geom)
}

ls <- set_up(ls_raw)
bars <- set_up(bars_raw)

#Container method to count ls/bars per municipality:

container_method <- function(df) {
  df <- df %>%
    group_by(SSN) %>%
    summarize("count" = sum(ones)) 
}

ls <- container_method(ls) %>%
  rename(count_ls = count)
bars <- container_method(bars) %>%
  rename(count_bars = count)

#Join:
alc_mun <- full_join(bars, ls)

#Prep to Write
st_write(alc_mun, "data_in_progress/alc_mun.csv")

