#Census Tract Master:

# Packages =====
library(tidyverse)
library(tidylog)
library(sf)


# Read Files  ====
usps2020 <- read.csv("data_raw/usps_vac_092020.csv") #Usps data
rd <- read.csv("data_in_progress/residential_data.csv") #Fanmei's residential data
#Note: IN this file 15 Census Tracts lack data entirely

tract <- st_read('data_raw/tl_2019_34_tract/tl_2019_34_tract.shp') #Spatial Tract Data
cross <- st_read('data_final/crosswalk_tract_mun.geojson') # Crosswalk


# Basic Set-Up  =====
#For a join of usps and rd files:  
usps2020$GEOID <- as.character(usps2020$geoid)
rd$GEOID <- as.character(rd$GEOID)

ct_master <- left_join(rd, usps2020) %>%
  left_join(cross, by = c("GEOID" = "TRACTID")) %>%
  select(-geoid) %>% #This is redundant as we have other GEOID
  relocate(c(GEOID, NAME, Place.Name)) #these get these columns out of the way for the simplicity of next call

#Crosswalk Function (to be called with across()):

crosswalk <- function(col) {
  prop_of_ct * col
}

# Test crosswalk data ========

#Get data to test on: 
ct_test <- ct_master %>%
  select(GEOID, Place.Name, total_units, pop_own_20yrs_plus, prop_of_ct)

#Manually:
ct_agg_to_mun <- ct_test %>%
  mutate(total_units_mun = total_units * prop_of_ct) %>%
  mutate(pop20_mun = pop_own_20yrs_plus * prop_of_ct) %>%
  group_by(Place.Name) %>%
  summarise("total_units_mun" = sum(total_units_mun), "pop20_mun" = sum(pop20_mun))

#With function:
ct_fn_agg_to_mun <- ct_test %>%
  mutate(across(pop_own_20yrs_plus:prop_of_ct, crosswalk()))

#Crosswalking from CT to Municipality:



# Spatial Data Setup ======


#Filter tract only to include spatial data and set CRS:
tract <- tract %>%
  select(COUNTYFP, GEOID, NAME) %>%
  st_transform(3424)

#Add spatial to other data:
ct_master_sp <- left_join(ct_master, tract) #sp adds the spatial element



#Write ======
st_write(ct_master, "data_in_progress/ct_master.geojson")
write.csv(ct_master_sp, "data_in_progress/ct_master.csv")
