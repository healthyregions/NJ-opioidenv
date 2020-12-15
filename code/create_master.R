#CREATING MASTER FILE
#note above line deals with municipality data
#Below line deals with census tract data

# Packages =====
library(tidyverse)
library(tidylog)
library(sf)

#Municipality Data ==================
#Joining Municipality Data:


alc_mun <- read.csv("data_in_progress/alc_mun.csv")
bike_paths <- read.csv("data_in_progress/bike_paths_mun.csv")
pe <- read.csv("data_in_progress/physical_environment_2015.csv")
ws_ed <- read.csv("data_in_progress/walkscore_education_mun_2012.csv")




mun_master <- left_join(pe, ws_ed, by = c("Place.ID" = "SSN")) %>%
  left_join(bike_paths, by = c("Place.ID" = "SSN")) %>%
  left_join(alc_mun, by = c("Place.ID" = "SSN")) %>%
  mutate(SSN = as.character(Place.ID)) %>%
  mutate(SSN = str_pad(SSN, 4, pad = "0"))







#-----------------------------------------------------------------
  
#Census Tract Data =============  
# Read Files  =====
usps2020 <- read.csv("data_raw/usps_vac_092020.csv") #Usps data
rd <- read.csv("data_in_progress/residential_data.csv") #Fanmei's residential data
#Note: IN this file 15 Census Tracts lack data entirely

tract <- st_read('data_raw/tl_2019_34_tract/tl_2019_34_tract.shp') #Spatial Tract Data
cross <- read.csv('data_final/cw_areal_interpolation.csv') # Crosswalk


# Basic Set-Up  =====

#JOIN ALL CENSUS TRACT DFS: 
#For a join of usps and rd files:  
usps2020$GEOID <- as.character(usps2020$geoid)
rd$GEOID <- as.character(rd$GEOID)
cross <- cross %>%
  mutate(TRACTID = as.character(TRACTID))

ct_master <- left_join(rd, usps2020) %>%
  left_join(cross, by = c("GEOID" = "TRACTID"))


#Crosswalking from CT to Municipality ====

#Clean to prepare for Crosswalk
ct_master <- ct_master %>%
  select(-geoid) %>% #This is redundant as we have other GEOID
  relocate(c(GEOID, NAME, Place.Name, prop_of_ct)) %>%#these get these columns out of the way for the simplicity of next call
  as.data.frame()

#Conduct Crosswalk:
prop_of_ct1 <- ct_master$prop_of_ct
  
ct_master <- ct_master %>%
  mutate(across(occupancy_rate:pqns_is_o, {~.x * prop_of_ct})) %>%
  group_by(SSN) %>%
  summarize(across(occupancy_rate:pqns_is_o, ~sum(., na.rm = T))) %>%
  mutate(SSN = as.character(SSN)) %>%
  mutate(SSN = str_pad(SSN, 4, pad = "0"))



#_________________________________________________________________________

#Combining Municipality and CT Data ==== 
master <- left_join(mun_master, ct_master, by = "SSN")


#Add spatial:
mun <- st_read("data_in_progress/mun_boundaries.geojson")
mun <- st_transform(mun, 3424) %>%
  select(SSN)

master_geog <- left_join(master, mun)
  
write.csv(master, "data_final/master.csv")
st_write(master_geog, "data_final/master_geog.geojson")
