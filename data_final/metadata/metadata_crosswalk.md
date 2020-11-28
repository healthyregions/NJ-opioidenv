Crosswalk_tract_mun.geojson

- Meta Data Name: metadata_crosswalk.md
- Date Last Modified: 11/28/2020
- Author: Gabe Morrison
- Data File Name: crosswalk_tract_mun.geojson
- Programming File Name(s): code/cross_walk.R
- Data Location: data_final

## DATA SOURCE(S):
NJ Census Tracts from NJGIN: https://njogis-newjersey.opendata.arcgis.com/datasets/91942afade1148bbbd6c4dbf414c8e1e

Municipality spatial whose cleaning was described in metadata_physical_environment_2015.md

## DESCRIPTION OF DATA FILE: 
Create an areal-weighted crosswalk between municipalities and census tracts in NJ. 


## DESCRIPTION OF DATA MANIPULATION:
I followed a tutorial by Jonathan Tannen extremely closely. See the link below.


## KEY VARIABLE NAMES AND DEFINITIONS:
**prop_of_ct**, which stands for proportion of census tract, is the key column. It tells what percent of the area of the census tract falls within a given municipality. If a census tract is divided between two municipalities, it will have two rows whose pro_of_ct sum to 1.00. 

Place.Name are the municipality names.
TRACTID are the unique identifiers for census tracts

## LINK TO DESCRIPTIVE STATISTICS:
na

## DATA LIMITIONS:
This crosswalk was is an "areal interpolation" meaning that it weights based on area as opposed to population. Thus it assumes equal distribution of people. 

## COMMENTS/NOTES:  
*Recommendations for how to use the data; ideas for future analyses or publications; record of relevant conversations about data* 
I believe the process that should be used to analyze the data is as follows:
(1) Import data at tract level
(2) Join data to this file by tract  
(3) for column X create new column X * prop_of_tract then group_by Place.Name and summarize(sum(X*prop_of_tract))




## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
*Including data citations with date data were downloaded and link, if available.*
Tutorial:https://sixtysixwards.com/home/crosswalk-tutorial/ (accessed 11/28/20)
NJ Census Tracts from NJGIN: https://njogis-newjersey.opendata.arcgis.com/datasets/91942afade1148bbbd6c4dbf414c8e1e (downloaded 11/28/20)

