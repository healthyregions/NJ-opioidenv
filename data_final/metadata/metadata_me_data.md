
# Dataset Name # 

- Meta Data Name: me_cleaning
- Date Last Modified: 07/12/21
- Author: Emily Selch
- Data File Name: me_data_geocode_complete.csv 
- Programming File Name(s): me_cleaning.R
- Data Location: Not uploaded to GitHub, can be found in the BEOM UIC - Address-level Data Box folder

## DATA SOURCE(S):
Data is from the NJ Medical Examiner. 

## DESCRIPTION OF DATA FILE: 
The data file combines NJ Medical Examiner annual data (already cleaned by Olina), standardizes column names, includes a variable geocoding addresses, and filters out all entries with a MatchScore less than 90.  

## DESCRIPTION OF DATA MANIPULATION:
1. I renamed all the column names from the already cleaned data files Olina uploaded to the NJ_deaths_data_cleaned folder on the Box
2. I created four new column names: year, category, person, and comments. Year is used to distinguish the four spreadsheets and the other variables are to be used for any future editing so that one can specify if the edit was manual/automatic, specify who they are, and provide any additional comments
3. I created two spreadsheets: one that includes the complete set of columns and the other that only includes the columns allowed for the geocode service
4. I read back in the geocoded spreadsheet and filtred out any entries that had a MatchScore of less than 90
5. I joined the complete spreadsheet to the filtered and geocoded spreadsheet, which is called me_data_geocode_complete.csv

## KEY VARIABLE NAMES AND DEFINITIONS:
CASEID: unique ID
MENOTIFIED: combination of data/time of death
MOD: manner of death
COD: cause of death
TOX_NOTES: Toxicology notes
RES_ADDRESS: Address of the deceased
RES_CITY: City the deceased lived in
RES_STATE: State the deceased lived in
RES_ZIP: Zip the deceased live in
FOUND: Where the deceased was found
FOUND_ADDRESS: Address of where the deceased was found
FOUND_CITY: City where the deceased was found
FOUND_ZIP: Zip where the deceased was found
Heroin - Methadone: 1 if the drug was present, 0 if not (Olina coded using the COD and toxicology notes)
Match Score: accuracy of Longitude and Latitude based off of RES_ADDRESS, RES_CITY, RES_STATE, and RES_ZIP

## LINK TO DESCRIPTIVE STATISTICS:

## DATA LIMITIONS: 

## COMMENTS/NOTES:  
There are a couple of entries from the cleaned spreadsheets that are missing information present in the original spreadsheets. Please see: CASEID: 14-16-0764 (missing MENOTIFIED information in the cleaned spreadsheet, which is present in the original spreadsheet). 
Additionally, CASEID: 20-16-0990 is split up across two entries in the cleaned spreadsheet for 2016. 
 
## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
