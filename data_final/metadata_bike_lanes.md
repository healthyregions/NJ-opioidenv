
# Dataset Name # 

- Meta Data Name: bike_lanes
- Date Last Modified: 11/18/20
- Author: Gabe Morrison
- Data File Name: ?
- Programming File Name(s): ?
- Data Location: ?

## DATA SOURCE(S):
Open Street Map; data downloaded October 11, 2020

## DESCRIPTION OF DATA FILE: 
Goal is to compute a measure of bike lanes in each municipality


## DESCRIPTION OF DATA MANIPULATION:
All of US Data downloaded from geofabrik: http://download.geofabrik.de/north-america.html
Osmium used to select only NJ Data with commands:
- osmium getid -r -t us-latest.osm.pbf r224951 -o nj-boundary.osm
- osmium extract -p nj-boundary.osm us-latest.osm.pbf -o nj.pbf



## KEY VARIABLE NAMES AND DEFINITIONS:

## LINK TO DESCRIPTIVE STATISTICS:
*Provide directory link to file with DS*

## DATA LIMITIONS:
*Data quality? Missing data and how it was dealt with? List geographic areas and years where data are problematic and how corrected.*

## COMMENTS/NOTES:  
*Recommendations for how to use the data; ideas for future analyses or publications; record of relevant conversations about data* 

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
*Including data citations with date data were downloaded and link, if available.*

