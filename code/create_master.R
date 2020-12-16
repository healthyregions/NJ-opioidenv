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
#STEP 1: READ DATA

usps2020 <- read.csv("data_raw/usps_vac_092020.csv") #Usps data
rd <- read.csv("data_in_progress/residential_data.csv") #Fanmei's residential data
#Note: IN this file 15 Census Tracts lack data entirely

pop <- read.csv("data_in_progress/nj_tract_pop_2016.csv")

tract <- st_read('data_raw/tl_2019_34_tract/tl_2019_34_tract.shp') #Spatial Tract Data
cross <- read.csv('data_final/cw_areal_interpolation.csv') # Crosswalk



#STEP 2: JOIN (AND MANIPULATION FOR JOIN)
usps2020$GEOID <- as.character(usps2020$geoid)
rd$GEOID <- as.character(rd$GEOID)
pop$GEOID <- as.character(pop$GEOID)
cross <- cross %>%
  mutate(TRACTID = as.character(TRACTID))

ct_master <- left_join(rd, usps2020) %>%
  left_join(pop) %>%
  left_join(cross, by = c("GEOID" = "TRACTID"))


#STEP 3: CROSSWALK

#Clean to prepare for Crosswalk
ct_master <- ct_master %>%
  select(-geoid) %>% #This is redundant as we have other GEOID
  relocate(c(GEOID, NAME, Place.Name, SSN, prop_of_ct)) %>%#these get these columns out of the way for the simplicity of next call
  as.data.frame()

#Conduct Crosswalk:
prop_of_ct1 <- ct_master$prop_of_ct
  
ct_master <- ct_master %>%
  mutate(across(occupancy_rate:pop2016, {~.x * prop_of_ct})) %>%
  group_by(SSN) %>%
  summarize(across(occupancy_rate:pop2016, ~sum(., na.rm = T))) %>%
  mutate(SSN = as.character(SSN)) %>%
  mutate(SSN = str_pad(SSN, 4, pad = "0"))



#_________________________________________________________________________

#Combining Municipality and CT Data ==== 
master <- left_join(mun_master, ct_master, by = "SSN")

#adding area:
mun <- st_read("data_in_progress/mun_boundaries.geojson")
mun_area <- st_transform(mun, 3424) %>%
  mutate(area = st_area(mun)) %>%
  as.data.frame() %>%
  select(SSN, area)

master <- left_join(master, mun_area)


#General new column computation and removal 
#Removing columns that were computed as percents and then crosswalked:
#Add ratios/percents columns
#Reorder to more intuitive form

master <- master %>%
  select(-c(occupancy_rate, vacancy_rate, mobile_home_rate)) %>% #Removed because the percent not appropriate for crosswalk
  select(-Place.ID) %>% #Redundant to SSN
  mutate(occupancy_rate = occupied_units / total_units) %>% #Recreate occupancy, vacancy, mobile home rates
  mutate(vacancy_rate = vacant_units / total_units) %>%
  mutate(mobile_home_rate = mobile_home / total_units) %>%
  mutate(bars_per_sqft = count_bars / area) %>% #Compute bar and liquor store rates per area and per pop
  mutate(bars_per_pop = count_bars / pop2016) %>%
  mutate(ls_per_sqft = count_ls / area) %>%
  mutate(ls_per_pop = count_ls / pop2016) %>%
  mutate(bars_ls_per_sqft = (count_bars + count_ls) / area) %>%
  mutate(bars_ls_per_pop = (count_bars + count_ls) / pop2016) %>%
  mutate(schools_per_pop = num_schools / pop2016) %>%
  select(-X) %>% #meaningless column removed
  relocate(SSN, .after = Place.Name) %>% #Reordering for more friendly usage 
  #relocate(occupancy_rate:mobile_home_rate, .before = multiunit_struct) %>%
  relocate(bars_per_sqft:bars_ls_per_pop, .after = count_ls) %>%
  relocate(c(pop2016, area), .after = SSN) %>%
  relocate(schools_per_pop, .after = num_schools)



#Writing Master============
#Add spatial:
mun_geog <- st_read("data_in_progress/mun_boundaries.geojson")
mun_geog <- st_transform(mun_geog, 3424) %>%
  select(SSN)

master_geog <- left_join(master, mun_geog)
  
write.csv(master, "data_final/master.csv")
st_write(master_geog, "data_final/master_geog.geojson")


