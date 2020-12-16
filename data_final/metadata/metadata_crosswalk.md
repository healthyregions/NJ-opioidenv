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
Note: there is also code creating a population-weighted interpolation but it hasn't been used

## DESCRIPTION OF DATA MANIPULATION:
I followed a tutorial by Jonathan Tannen. However, I updated to calculate what percent of the municipality each fragment of the census tract constituted. That is, if a census tract was entirely in one municipality and its area constituted 50% of the municility, it would not be divided in the st_transform call and then it would have a .5 in the pct of mun column. 



## KEY VARIABLE NAMES AND DEFINITIONS:
**pct_of_mun**, which stands for percent of municipality. It tells what the area of the census tract (or fragment) constitutes as an area of the entire municipality. 

Place.Name are the municipality names.
TRACTID are the unique identifiers for census tracts

## LINK TO DESCRIPTIVE STATISTICS:
na

## DATA LIMITIONS:
This crosswalk was is an "areal interpolation" meaning that it weights based on area as opposed to population. Thus it assumes equal distribution of people. 

## COMMENTS/NOTES:  
*Recommendations for how to use the data; ideas for future analyses or publications; record of relevant conversations about data* 




## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
*Including data citations with date data were downloaded and link, if available.*
Tutorial:https://sixtysixwards.com/home/crosswalk-tutorial/ (accessed 11/28/20)
NJ Census Tracts from NJGIN: https://njogis-newjersey.opendata.arcgis.com/datasets/91942afade1148bbbd6c4dbf414c8e1e (downloaded 11/28/20)

