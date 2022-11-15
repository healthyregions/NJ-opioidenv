
# Dataset Name # 

- Meta Data Name: usps_vac_2018
- Date Last Modified: 1/19/20
- Author: Fanmei Xia
- Data File Name: usps_vac_2018_variables
- Programming File Name(s): usps_vac_2018_variables.csv
- Data Location: data_in_progress

## DATA SOURCE(S):
USPS; data last accessed Nov 20, 2020

## DESCRIPTION OF DATA FILE: 
Find proxies to construct business/residential conditions in New Jersey


## DESCRIPTION OF DATA MANIPULATION:

### Step 1: Reading 
All data downloaded from USPS website
Check for available variables in the USPS dictionary

Pulled tract level data of New Jersey:
#### identify variables from AMS: Total Count of Addresses 
  1. Business: ams_bus	

#### identify variables from VAC: Total Count of Vacant Addresses 
  1. Business: bus_vac 


### Step 2: Compute Occupance/Vancancy Rate
  1. Business Vacancy Rate: bus_vac_rate = bus_vac/ams_bus

### Step 3: Write Data


## KEY VARIABLE NAMES AND DEFINITIONS
geoid
ams_bus: total count of business addresses
bus_vac: total count of vacant addresses
bus_vac_rate: business vacacy rate

## LINK TO DESCRIPTIVE STATISTICS:
Data in data_in_progress/usps_vac_2018_variables.cvs


## DATA LIMITIONS: 


## COMMENTS/NOTES:  
 



## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
https://www.huduser.gov/portal/usps/home.html

