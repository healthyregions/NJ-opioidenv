## Data Processing for NJ Land Use 

##Goals:
### Convert that data into proportion of land use in each municipality used for (1) industry (2) commercial and (3) residential
### Calculate residential density data

#Packages to load ======
library(tidyverse)
library(tidylog)
library(sf)
library(tmap)
library(janitor)
library(smoothr)
library(rmapshaper)

#Read Data ===== 

setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")

land_use <- read.csv('nj_land_use_state_county_municipality_1986_2015.csv', header=TRUE, stringsAsFactors = FALSE, dec = ",")


#Clean Data

#Section 1: Reshape, remove unnecessary columns, convert to correct type =======
land_use <- land_use %>%
  select(-starts_with(c("Change.in", "Percentage.Change"))) %>% #removes columns that show change and % change in land use
  mutate(description2 = as.character(Descriptiion)) %>% #creates new column as character to allow for filter on next line
  filter(str_detect(description2, "URBAN|Urban|Commercial|Residential|Industrial|Transportation")) %>% #filters only land uses of interest
  filter(!str_detect(description2, "Phragmites Dominate Urban Area")) %>% #removes unnecessary rows about Phragmites
  select(-Descriptiion) %>% #removes unnecessary column
  mutate_at("Use.Level", as.factor) %>%
  filter(Place.ID > 21 | Place.ID == 0) #This gets rid of counties so that data includes municipalities only
  

#Struggling to make a mutate_at or across() function  work, so inelegantly:

land_use$Acreage.1986 <- as.numeric(str_replace_all(land_use$Acreage.1986, ",", ""))
land_use$Acreage.1995 <- as.numeric(str_replace_all(land_use$Acreage.1995, ",", ""))
land_use$Acreage.2002 <- as.numeric(str_replace_all(land_use$Acreage.2002, ",", ""))
land_use$Acreage.2007 <- as.numeric(str_replace_all(land_use$Acreage.2007, ",", ""))
land_use$Acreage.2015 <- as.numeric(str_replace_all(land_use$Acreage.2015, ",", ""))
land_use$Place.Total.Area <- as.numeric(str_replace_all(land_use$Place.Total.Area, ",", ""))


#these two ifelse statements are also inelegant, but they respond to the issue that "residential" had been a category 
#both to summarize all residential areas and as residential that wasn't included in other categories
land_use$description3 <- ifelse(land_use$description2 == "Residential" & land_use$Use.Level == "3",
                                "Residential (Other)", land_use$description)
land_use$description <- ifelse(land_use$description3 == "Residential" & land_use$Use.Level == "2",
                               "Residential (Total)", land_use$description3)


land_use <- land_use %>%
  select(-c("description2", "description3")) #get rid of extra columns made in the ifelse work above



# Section 2: Creates new columns ======= 


# Part A ==== 

#Percentage or residential, commercial, and industrial out of all urban land and all land 

#Note that these do not sum to 100% or 1 because there are other land uses not included (in urban- transportation)
#Also note that the measures of industry include classifications both of industry themselves and of "Industrial and Commerical complexes)

#land_use_2015_proportions gives overall area and proportion of area used by each of residential, commerical, industrial 
land_use_2015_proportions <- land_use %>%
  filter(Use.Level !=3) %>%
  select(Place.ID:Place.Name, Acreage.2015:description) %>%
  pivot_wider(names_from = "description", values_from = "Acreage.2015") %>%
  replace(is.na(.), 0) %>%
  mutate(pct_res_urb = `Residential (Total)` / URBAN) %>% 
  mutate(pct_com_urb = `Commercial and Services` / URBAN) %>%
  mutate(pct_ind_urb = (Industrial + `Industrial and Commercial Complexes`) /URBAN) %>%
  mutate(pct_res_tot = `Residential (Total)` / Place.Total.Area) %>%
  mutate(pct_com_tot = `Commercial and Services` / Place.Total.Area) %>%
  mutate(pct_ind_tot = (Industrial + `Industrial and Commercial Complexes`) / Place.Total.Area)


# Part B ==== 
#residential_2015 gives overall area devoted to different types of residential densities 
#and proportion of high-density (and not high-density) to total residential area 

residential_2015 <- land_use %>%
  filter(str_detect(description, "Residential")) %>%
  select(Place.ID:Place.Name, Acreage.2015:description, -Place.Total.Area) %>%
  pivot_wider(names_from = "description", values_from = "Acreage.2015") %>% 
  replace(is.na(.), 0) %>%
  mutate(pct_h_den_res = `Residential (High Density or Multiple Dwelling)`/`Residential (Total)`) %>%
  mutate(pct_n_h_density_res = 1-pct_h_den_res)




#physical_environment_2015 gives that df only of the percentage values, which likely are the most valuable for the research 
physical_environment_2015 <- residential_2015 %>%
  select(c(Place.ID, Place.Name, pct_h_den_res, pct_n_h_density_res)) %>%
  left_join(land_use_2015_proportions) %>%
  select(-c(Place.Total.Area:`Other Urban or Built-up Land`)) %>%
  mutate(Place.Name = tolower(Place.Name)) %>%
  filter(Place.Name != "statewide")



#Writing File
st_write(physical_environment_2015, "data_in_progress/physical_environment_2015.csv")


