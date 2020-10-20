## Data Processing for NJ Land Use 

##Goals:
### Convert that data into proportion of land use in each municipality used for (1) industry (2) commercial and (3) residential
### Calculate residential density data

#Packages to load ======
library(tidyverse)
library(tidylog)
library(sf)


#Read Data:
land_use <- read.csv('data_raw/nj_land_use_state_county_municipality_1986_2015.csv')


#Clean Data: 
land_use <- land_use %>%
  select(-starts_with(c("Change.in", "Percentage.Change"))) %>% #removes columns that show change and % change in land use
  filter(Use.Level == "2")


unique(land_use$Place.Name, incomparables = F)
unique(land_use$Place.ID)
