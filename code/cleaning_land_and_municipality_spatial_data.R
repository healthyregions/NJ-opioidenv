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

#Read Data ===== 
land_use <- read.csv('data_raw/nj_land_use_state_county_municipality_1986_2015.csv', header=TRUE, stringsAsFactors = FALSE, dec = ",")


#Clean Data =====
land_use <- land_use %>%
  select(-starts_with(c("Change.in", "Percentage.Change"))) %>% #removes columns that show change and % change in land use
  mutate(description2 = as.character(Descriptiion)) %>% #creates new column as character to allow for filter on next line
  filter(str_detect(description2, "URBAN|Urban|Commercial|Residential|Industrial|Transportation")) %>% #filters only land uses of interest
  filter(!str_detect(description2, "Phragmites Dominate Urban Area")) %>% #removes unnecessary rows about Phragmites
  select(-Descriptiion) %>% #removes unnecessary column
  mutate_at("Use.Level", as.factor) %>%
  filter(Place.ID > 21) #This gets rid of counties so that data includes municipalities only
  

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



#Creates new dfs more targetted towards near-term use: 
#This one calculates the percentage or residential, commercial, and industrial out of all urban land and all land in general
#Note that these do not sum to 100% or 1 because there are other land uses not included (in urban- transportation)
#Also note that the measures of industry include classifications both of industry themselves and of "Industrial and Commerical complexes)

#land_use_2015_proportions gives overall area and proportion of area used by each of residential, commerical, industrial 
land_use_2015_proportions <- land_use %>%
  filter(Use.Level !=3) %>%
  select(Place.ID:Place.Name, Acreage.2015:description) %>%
  pivot_wider(names_from = "description", values_from = "Acreage.2015") %>%
  replace(is.na(.), 0) %>%
  mutate(pct_residential_of_urban = `Residential (Total)` / URBAN) %>% 
  mutate(pct_commercial_of_urban = `Commercial and Services` / URBAN) %>%
  mutate(pct_industrial_of_urban = (Industrial + `Industrial and Commercial Complexes`) /URBAN) %>%
  mutate(pct_residential_of_total = `Residential (Total)` / Place.Total.Area) %>%
  mutate(pct_commercial_of_total = `Commercial and Services` / Place.Total.Area) %>%
  mutate(pct_industrial_of_total = (Industrial + `Industrial and Commercial Complexes`) / Place.Total.Area)

#residential_2015 gives overall area devoted to different types of residential densities 
#and proportion of high-density (and not high-density) to total residential area 

residential_2015 <- land_use %>%
  filter(str_detect(description, "Residential")) %>%
  select(Place.ID:Place.Name, Acreage.2015:description, -Place.Total.Area) %>%
  pivot_wider(names_from = "description", values_from = "Acreage.2015") %>% 
  replace(is.na(.), 0) %>%
  mutate(pct_high_density_res = `Residential (High Density or Multiple Dwelling)`/`Residential (Total)`) %>%
  mutate(pct_not_high_density_res = 1-pct_high_density_res)

#physical_environment_2015 gives that df only of the percentage values, which likely are the most valuable for the research 
physical_environment_2015 <- residential_2015 %>%
  select(c(Place.ID, Place.Name, pct_high_density_res, pct_not_high_density_res)) %>%
  left_join(land_use_2015_proportions) %>%
  select(-c(Place.Total.Area:`Other Urban or Built-up Land`, `Industrial and Commercial Complexes`)) %>%
  mutate(Place.Name = tolower(Place.Name)) %>%
  clean_names()
colnames(physical_environment_2015)

#Read and some cleaning of municipal boundaries shapefile:
mun_boundaries <- st_read('data_raw/Municipal_Boundaries_of_NJ.shp')
mun_boundaries <- mun_boundaries %>%
  select(c("MUN", "MUN_TYPE", "GNIS", "SSN", "MUN_CODE", "geometry")) %>% #Grab only relevant variables
  rename(place_name = MUN) %>% #rename column for join
  clean_names() 
mun_boundaries$place_name <- tolower(mun_boundaries$place_name)


#Joining municipal boundaries shapefile and physical environment data
pe2015 <- left_join(mun_boundaries, physical_environment_2015) #%>%
  #distinct(.keep_all = T)


#Writing Files:
st_write(pe2015, "data_raw/pe_2015_spatial.geojson")


#




#Visualizing Options for Residential, Commercial, Industrial Land Use




