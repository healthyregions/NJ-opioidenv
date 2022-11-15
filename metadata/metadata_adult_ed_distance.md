
# adult_ed_distance

- Meta Data Name: adult_ed_distance
- Date Last Modified: 4/21/2021
- Author: Emily Selch
- Data File Name: adult_ed_distance.csv
- Programming File Name(s): 
- Data Location: data_final

## DATA SOURCE(S): 
Original data filed downloaded from NJGIN Open Data at:
https://njogis-newjersey.opendata.arcgis.com/datasets/school-point-locations-of-nj-public-private-and-charter?geometry=-81.880%2C38.635%2C-67.564%2C41.575&orderBy=X


## DESCRIPTION OF DATA FILE: 
The purpose of this data file is to calculate the average distance from each municipality to the nearest adult education program. 

## DESCRIPTION OF DATA MANIPULATION:
1) I filtered out adult education programs, as specified in the school type column
2) I  cleaned the address column prior to geocoding the points
3) I reprojected the adult education programs, census tracts, and municipality dataframes into 103105 so that distances can be calculated in meaningful units
4) I created a dataframe of the tract centroids and then calculated the distance from each census tract centroid to the nearest adult education program
5) I converted the distance units into miles
6) I weighted the distance measure for each census tract according to the proportion of the census tract within the municipality
7) I aggregtated the distance at each census tract up to the municipal level 

## KEY VARIABLE NAMES AND DEFINITIONS:

SSN: unique identifier for the municipality
average_d_adultEd: average distance to the nearest adult education program

## LINK TO DESCRIPTIVE STATISTICS:
*Provide directory link to file with DS*

## DATA LIMITIONS:
There were some adult education programs coded in the school type as vocational, but the vocational category
also included non-adult education programs so I did not include any vocational programs in this analysis.  

## COMMENTS/NOTES:  

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
https://njogis-newjersey.opendata.arcgis.com/datasets/school-point-locations-of-nj-public-private-and-charter?geometry=-81.880%2C38.635%2C-67.564%2C41.575&orderBy=X

