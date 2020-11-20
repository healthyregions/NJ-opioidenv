
# Dataset Name # 

- Meta Data Name: meta_data_walkscore
- Date Last Modified: 2 November 2020
- Author: Gabriel Morrison
- Data File Name: walkscore_education_bg_2013.geojson
- Programming File Name(s): walkscore.R  
- Data Location: data_in_progress

## DATA SOURCE(S):
CSDS's copy of 2013 data from Walkscore (https://www.walkscore.com) 
2013 block group data https://catalog.data.gov/dataset/tiger-line-shapefile-2013-state-new-jersey-current-block-group-state-based


## DESCRIPTION OF DATA FILE: 
The goal of this data is twofold. First is to categorize regions (in this dataset block group, but ultimately municipalities') "walkability". Second is to assess their quality of public schools. 

## DESCRIPTION OF DATA MANIPULATION:
filtered only to include data from NJ
filtered only to include columns relevant to walkscore and education variables

## KEY VARIABLE NAMES AND DEFINITIONS:
GEOID - unique identifier of block groups
CBSA - city code 
CBSA_NAME - name of city 
SSWS2USE - "Street-smart walkscore: .25 street-based access to amenities, weighted by intersection density etc." see notes for more details. *Note that this is for 2012*
ED1_NO - Total number of parcels categorized as ED1 (Elementary, Junior-High, and High School)
ED1_PERC -% area of parcels classified as ED1 (Elementary, Junior-High, and High Schools)
ED2_NO - Total number of parcels classified as ED2 (University or college, other types of education/institution)
ED2_PERC - % area of parcels classified as ED2 (University or college, other types of education/institution)

## LINK TO DESCRIPTIVE STATISTICS:
/data_in_progress/walkscore_education_bg_2013.geojson


## DATA LIMITIONS:
As noted below SSWS2Use is highly manipulated (before this project). 
Joined to block group data from 2013. This should not be a problem. 

## COMMENTS/NOTES:  
Note on SSWS2Use: "Closest address to block group centroid and for core areas of 6 metros and other cities, block centroids. March 2012. If SSWS field was zero and there were road network problems, we used the regular straight-line distance WS value instead to avoid fake zeros due to data errors."

Gabe would recommend crosswalking to municipalities by aggregating SSWS2USE as a population weighted mean and summing the ED1 and ED2_no. Gabe thinks if a municipality-level ED1 or ED2_PERC measure is to be used, it should be recalculated given that crosswalking could warp the data. 


## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
CSDS's copy to walkscore data. 
Shapefile from Census: https://catalog.data.gov/dataset/tiger-line-shapefile-2013-state-new-jersey-current-block-group-state-based

