
# Dataset Name # 

- Meta Data Name: rent
- Date Last Modified: 6/9/21
- Author: Fanmei Xia
- Data File Name: rent
- Programming File Name(s): rent.R
- Data Location: data_final

## DATA SOURCE(S):
Census/ACS; data last accessed June 10, 2020

## DESCRIPTION OF DATA FILE: 
Find proxies to construct residential conditions in New Jersey


## DESCRIPTION OF DATA MANIPULATION:

### Step 1: Reading 
All data pulled using R's package/API
Check for available variables in the census data (in this case American Community Survey)

Pulled tract level data of New Jersey:
B25063_001	Estimate!!Total	GROSS RENT

### Step 2: Compute Occupance/Vancancy Rate, Mobile Home Percentage, Multi-Units Structure, Population who have moved in for more than 20 years
occupancy_rate = occupied_units/total_units, 
vacancy_rate = vacant_units/total_units,
mobile_home_rate = mobile_home/total_units,
multiunit_struct = multiunits_two + multiunits_three_or_four + multiunits_five_to_nine + multiunits_10_to_19 + multiunits_20_to_49 + multiunits_50plus,
pop_own_20yrs_plus = pop_own_90_99 + pop_own_bfr89,
pop_ren_20yrs_plus = pop_ren_90_99 + pop_ren_bfr89,
pop_20yrs_plus = pop_own_20yrs_plus + pop_ren_20yrs_plus

### Step 3: Write Data

## KEY VARIABLE NAMES AND DEFINITIONS:

rent_gross: gross rent

## LINK TO DESCRIPTIVE STATISTICS:
Data in data_final/rent.Rmd


## DATA LIMITIONS: 


## COMMENTS/NOTES:  
 



## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
Census/ACS: https://www.census.gov/data.html

