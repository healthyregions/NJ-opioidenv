#Combining Physical Environment and Space:

library(tidylog)
library(tidyverse)
library(sf)
library(janitor)
library(tmap)



pe2015 <- read.csv("data_raw/physical_environment_2015.csv")
pe2015 <- pe2015[,-1 ]

mun_data <- st_read("data_raw/Govt_admin_mun_coast_bnd/Govt_admin_mun_coast_bnd.shp")
mun_data <- clean_names(mun_data)
mun_data$place_name <- tolower(mun_data$mun)


pe2015_spatial2 <- st_read('data_raw/pe2015.geojson')
