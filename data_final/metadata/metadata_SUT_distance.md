
# Dataset Name # 

- Meta Data Name: Average municipal distance to substance use treatment sites
- Date Last Modified: 7/20/2021
- Author: Christian Villanueva
- Data File Name: SUT_distance.csv
- Programming File Name(s): SUT_distance.R
- Data Location: data_final

## DATA SOURCE(S):
https://findtreatment.samhsa.gov/locator

## DESCRIPTION OF DATA FILE: 
The purpose of this data file is to calculate the average distance from each municipality to the nearest substance use treatment site and the proportion of tracts within a municipality that are within 10 miles of a substance use treatment site.

## DESCRIPTION OF DATA MANIPULATION:
1) I geocoded the SUT sites using the RCC-GIS GeocodingService and dropped entries with a score less than 90 percent
2) I converted the SUT points into a shapefile
3) I reprojected the SUT shapefile, census tracts, and municipality dataframes into 103105 so that distances can be calculated in meaningful units
4) I created a dataframe of the tract centroids and then calculated the distance from each census tract centroid to the nearest SUT site
5) I converted the distance units into miles
6) I weighted the distance measure for each census tract according to the proportion of the census tract within the municipality
7) For municipal level aggregation 
 - I aggregtated the distance at each census tract up to the municipal level
9) For proprtion under 10 miles
 - I created a dummy variable to tally all tracts and another variable to tally distances less than 10 miles
 - I generated a proportion of tracts within 10 miles of an SUT site by municipality

## KEY VARIABLE NAMES AND DEFINITIONS:
SSN: unique municipality identifier 
avg_min_dist: average distance (renamed when merging to avg_SUT_min_dist)
prop_under_10mi: proprtion of tracts within a municipality within 10miles of an SUT site (renamed when merging to SUT_prop_under_10mi)

## LINK TO DESCRIPTIVE STATISTICS:
*Provide directory link to file with DS*

## DATA LIMITIONS:
None to my knowledge. The street addresses of SUT sites were sent to us by the UIC team.

## COMMENTS/NOTES:  
*Recommendations for how to use the data; ideas for future analyses or publications; record of relevant conversations about data* 

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
*Including data citations with date data were downloaded and link, if available.*

