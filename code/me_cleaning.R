library(dplyr)
library(tidyverse)

# read in cleaned spreadsheets from Olina

setwd("~/Desktop/Harris/Opioid - RA/medical examiner/Olina - cleaned")

X2015_Olina <- read_csv("2015_Olina.csv")
X2016_Olina <- read_csv("2016_Olina.csv")
X2017_Olina <- read_csv("2017_Olina.csv")
X2018_Olina <- read_csv("2018_Olina.csv")

# rename column names for the complete spreadsheet and for the one to be uploaded to the geocoding service 

# 2015

X2015_clean <- X2015_Olina %>%
  rename(AGE = "Age",
         RACE = "Race",
         GENDER = "Gender",
         TOX_NOTES = "Tox Notes",
         RES_ADDRESS = "Decedent Street Address",
         RES_CITY = "DecedentCity",
         RES_STATE = "DecedentState",
         RES_ZIP = "DecedentZip",
         FOUND = "Location Found/Injury Observed/Onset of Illness",
         FOUND_ADDRESS = "Location Found/Injury Observed/Onset of Illness.1",
         FOUND_CITY = "City",
         FOUND_ZIP = "Zip") %>%
  mutate(YEAR = "2015") %>%
  add_column(category = NA,
             person = NA,
             comments = NA) %>%
  select(CASEID, MENOTIFIED, AGE, RACE, GENDER, MOD, COD, TOX_NOTES, RES_ADDRESS, RES_CITY, RES_STATE, RES_ZIP,
         FOUND, FOUND_ADDRESS, FOUND_CITY, FOUND_ZIP, Heroin, Fentanyl, Morphine, Oxycodone, Methadone, YEAR,
         category, person, comments)

X2015_clean_bind <- X2015_clean %>%
  select(CASEID, MENOTIFIED, RES_ADDRESS, RES_CITY, RES_ZIP, RES_STATE)  


#2016

X2016_clean <- X2016_Olina %>%
  rename(AGE = "Age",
         RACE = "Race",
         GENDER = "Gender",
         COD = "CauseOfDeath",
         TOX_NOTES = "Tox Notes",
         RES_ADDRESS = "Decedent Street Address",
         RES_CITY = "DecedentCity",
         RES_STATE = "DecedentState",
         RES_ZIP = "DecedentZip",
         FOUND = "Location Found/Injury Observed/Onset of Illness",
         FOUND_ADDRESS = "Location Found/Injury Observed/Onset of Illness.1",
         FOUND_CITY = "City",
         FOUND_ZIP = "Zip") %>%
  mutate(YEAR = "2016") %>%
  add_column(category = NA,
             person = NA,
             comments = NA) %>%
  select(CASEID, MENOTIFIED, AGE, RACE, GENDER, MOD, COD, TOX_NOTES, RES_ADDRESS, RES_CITY, RES_STATE, RES_ZIP,
         FOUND, FOUND_ADDRESS, FOUND_CITY, FOUND_ZIP, Heroin, Fentanyl, Morphine, Oxycodone, Methadone, YEAR,
         category, person, comments)

X2016_clean_bind <- X2016_clean %>%
  select(CASEID, MENOTIFIED, RES_ADDRESS, RES_CITY, RES_ZIP, RES_STATE)

# 2017

X2017_clean <- X2017_Olina %>%
  rename(MENOTIFIED = "Reported",
         AGE = "Age",
         RACE = "Race",
         GENDER = "Gender",
         TOX_NOTES = "Toxicology Notes",
         RES_ADDRESS = "Residence Address",
         RES_CITY = "Residence City",
         RES_STATE = "State",
         FOUND = "Location where found",
         FOUND_CITY = "City",
         FOUND_ZIP = "Zip") %>%
  select(CASEID, MENOTIFIED, AGE, RACE, GENDER, RES_ADDRESS, RES_CITY, RES_STATE, FOUND, FOUND_CITY,
         FOUND_ZIP, MOD, COD, TOX_NOTES, Heroin, Fentanyl, Morphine, Cocaine, Oxycodone, Methadone) %>%
  mutate(YEAR = "2017") %>%
  add_column(category = NA,
             person = NA,
             comments = NA,
             RES_ZIP = NA,
             FOUND_ADDRESS = NA) %>%
  select(CASEID, MENOTIFIED, AGE, RACE, GENDER, MOD, COD, TOX_NOTES, RES_ADDRESS, RES_CITY, RES_STATE, RES_ZIP,
         FOUND, FOUND_ADDRESS, FOUND_CITY, FOUND_ZIP, Heroin, Fentanyl, Morphine, Oxycodone, Methadone, YEAR,
         category, person, comments)

X2017_clean_bind <- X2017_clean %>%
  select(CASEID, MENOTIFIED, RES_ADDRESS, RES_CITY, RES_ZIP, RES_STATE) 

# 2018

X2018_clean <- X2018_Olina %>%
  rename(AGE = "Age",
         RACE = "Race",
         GENDER = "Gender",
         TOX_NOTES = "Toxicology Notes",
         RES_ADDRESS = "Residence Address",
         RES_CITY = "Residence City",
         RES_STATE = "State",
         FOUND = "Location where found",
         FOUND_CITY = "City",
         FOUND_ZIP = "Zip") %>%
  select(CASEID, MENOTIFIED, AGE, RACE, GENDER, RES_ADDRESS, RES_CITY, RES_STATE, FOUND, FOUND_CITY,
         FOUND_ZIP, MOD, COD, TOX_NOTES, Heroin, Fentanyl, Morphine, Cocaine, Oxycodone, Methadone) %>%
  mutate(YEAR = "2018") %>%
  add_column(RES_ZIP = NA,
             FOUND_ADDRESS = NA,
             category = NA,
             person = NA,
             comments = NA) %>%
  select(CASEID, MENOTIFIED, AGE, RACE, GENDER, MOD, COD, TOX_NOTES, RES_ADDRESS, RES_CITY, RES_STATE, RES_ZIP,
         FOUND, FOUND_ADDRESS, FOUND_CITY, FOUND_ZIP, Heroin, Fentanyl, Morphine, Oxycodone, Methadone, YEAR,
         category, person, comments)

X2018_clean_bind <- X2018_clean %>%
  select(CASEID, MENOTIFIED, RES_ADDRESS, RES_CITY, RES_ZIP, RES_STATE) 

# transform columns to be in the same class type to prepare for binding 

class(X2015_clean_bind$CASEID)
class(X2016_clean_bind$CASEID)
class(X2017_clean_bind$CASEID)
class(X2018_clean_bind$CASEID)

str(X2015_clean_bind)
str(X2016_clean_bind)
str(X2017_clean_bind)
str(X2018_clean_bind)

X2015_clean_bind$MENOTIFIED <- as.character(X2015_clean_bind$MENOTIFIED)
X2016_clean_bind$MENOTIFIED <- as.character(X2016_clean_bind$MENOTIFIED)
X2018_clean_bind$MENOTIFIED <- as.character(X2018_clean_bind$MENOTIFIED)
X2016_clean_bind$RES_ZIP <- as.character(X2016_clean_bind$RES_ZIP)
X2017_clean_bind$RES_ZIP <- as.character(X2017_clean_bind$RES_ZIP)
X2018_clean_bind$RES_ZIP <- as.character(X2018_clean_bind$RES_ZIP)

# bind spreadsheets in order to create one spreadsheet to upload to the geocoding service 

me_data_clean_geocode <- rbind(X2015_clean_bind, X2016_clean_bind, X2017_clean_bind, X2018_clean_bind)

X2015_clean$MENOTIFIED <- as.character(X2015_clean$MENOTIFIED)
X2016_clean$MENOTIFIED <- as.character(X2016_clean$MENOTIFIED)
X2018_clean$MENOTIFIED <- as.character(X2018_clean$MENOTIFIED)
X2016_clean$RES_ZIP <- as.character(X2016_clean$RES_ZIP)
X2017_clean$RES_ZIP <- as.character(X2017_clean$RES_ZIP)
X2018_clean$RES_ZIP <- as.character(X2018_clean$RES_ZIP)

me_data_clean_geocode <- me_data_clean_geocode %>%
  rename(ADDRESS = "RES_ADDRESS",
         CITY = "RES_CITY",
         ZIP = "RES_ZIP",
         STATE = "RES_STATE")

me_data_clean_geocode <- me_data_clean_geocode %>%
  select(CASEID, ADDRESS, CITY, ZIP, STATE)

write_csv(me_data_clean_geocode, "me_data_clean_geocode.csv")

# bind complete spreadsheets (all columns) to be merged with the geocoded spreadsheet 

me_data_clean <- rbind(X2015_clean, X2016_clean, X2017_clean, X2018_clean)

write_csv(me_data_clean, "me_data_clean.csv")

# read in the geocoded data and rename columns to merge with the complete spreadsheet

me_data_geocoded <- read_csv("me_data_clean_geocode_1622150767_geocoded.csv")

me_data_geocoded <- me_data_geocoded %>%
  rename(RES_ADDRESS = "ADDRESS",
         RES_CITY = "CITY",
         RES_ZIP = "ZIP",
         RES_STATE = "STATE")

# remove entries with a Match Score less than 90 

me_data_geocoded_fitered <- me_data_geocoded %>%
  filter(`Match Score` >= 90)

# join the spreadsheet with the complete set of columns to the filtered, geocoded spreadsheet 

me_data_geocoded_fitered <- me_data_geocoded_fitered %>%
  left_join(me_data_clean, c("CASEID" = "CASEID"))

# remove duplicate columns from joined spreadsheet

me_data_geocode_complete <- me_data_geocoded_fitered %>%
  rename(RES_ADDRESS = "RES_ADDRESS.x",
         RES_CITY = "RES_CITY.x",
         RES_ZIP = "RES_ZIP.x",
         RES_STATE = "RES_STATE.x") %>%
  select(CASEID, MENOTIFIED, AGE, RACE, GENDER, MOD, COD, TOX_NOTES, RES_ADDRESS, RES_CITY, RES_STATE, RES_ZIP,
         FOUND, FOUND_ADDRESS, FOUND_CITY, FOUND_ZIP, Heroin, Fentanyl, Morphine, Oxycodone, Methadone, YEAR, Longitude,
         Latitude, `Match Score`, category, person, comments)

write_csv(me_data_geocode_complete, "me_data_geocode_complete.csv")