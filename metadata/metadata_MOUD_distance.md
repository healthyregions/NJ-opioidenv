
# Dataset Name # 

- Meta Data Name: Average municipal distance to providers prescribing Medications for Opioid Overuse Disorder (MOUDs) and their locations
- Date Last Modified: 7/20/2021
- Author: Christian Villanueva
- Data File Name: MOUD_distance_municipality.csv
- Programming File Name(s): MOUD_agg.R
- Data Location: data_final

## DATA SOURCE(S):
https://findtreatment.samhsa.gov/locator at tract level by Susan Paykin

## DESCRIPTION OF DATA FILE: 
The purpose of this data file is to calculate the average distance from each municipality to the nearest providers prescribing Medications for Opioid Overuse Disorder (MOUDs) and the proportion of tracts within a municipality within 10 miles of a provider

## DESCRIPTION OF DATA MANIPULATION:
1) Data was provided at tract level and merged with crosswalk data set
2) I weighted the distance measure for each census tract according to the proportion of the census tract within the municipality
3) For municipal level aggregation 
 - I aggregtated the distance at each census tract up to the municipal level
4) For proprtion under 10 miles
 - I created a dummy variable to tally all tracts and another variable to tally distances less than 10 miles
 - I generated a proportion of tracts within 10 miles of MOUD site by municipality

## KEY VARIABLE NAMES AND DEFINITIONS:
SSN: unique municipality identifier 

avg_min_dist: average distance (renamed when merging to avg_MOUD_min_dist)

prop_under_10mi: proprtion of tracts within a municipality within 10miles of an MOUD site (renamed when merging to MOUD_prop_under_10mi)

## LINK TO DESCRIPTIVE STATISTICS:
*Provide directory link to file with DS*

## DATA LIMITIONS:
None to my knowledge.

## COMMENTS/NOTES:  
*Recommendations for how to use the data; ideas for future analyses or publications; record of relevant conversations about data* 
merging through left_join resulted in many NAs whereas merge() did not, unclear why

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
*Including data citations with date data were downloaded and link, if available.*

