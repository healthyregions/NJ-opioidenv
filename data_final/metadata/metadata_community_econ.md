
# Dataset Name # 

- Meta Data Name: Community Economy
- Date Last Modified: 6/9/21
- Author: Fanmei Xia
- Data File Name: community_econ.csv
- Programming File Name(s): community_econ.R
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
B19301_001: income per capita
B23025_001: employment status for the population 16 years and over
B23025_004: employed of the population 16 years and over who are in the labor force
B23025_005: unemployed of the population 16 years and over who are in the labor force

### Step 2: Cleaning
calcuated the employment per capita by the number of people employed (employed), over the total population (employ_total).

### Step 3: Write Data

### Step 4: Merge and Aggregate Data
1) I weighted the income and employment measure for each census tract according to the proportion of the census tract within the municipality
2) I aggregated to the municipal level

## KEY VARIABLE NAMES AND DEFINITIONS:

income_per_cap: income per capita (income_per_capita in master)
employ_per_cap: employment per capita (employment_per_capita in master

## LINK TO DESCRIPTIVE STATISTICS:
Data in data_final/community_econ.Rmd


## DATA LIMITIONS: 
Some NAs had to be removed when aggregating (32 of 599 observations once merged with the crosswalk file)

## COMMENTS/NOTES:  
 



## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
Census/ACS: https://www.census.gov/data.html

