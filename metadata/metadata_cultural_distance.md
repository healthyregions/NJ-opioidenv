
# Dataset Name # 

- Meta Data Name: Average municipal distance to cultural centers
- Date Last Modified: 4/21/2021
- Author: Emily Selch 
- Data File Name: cultural_distance.csv
- Programming File Name(s): cultural_distance.csv
- Data Location: data_final

## DATA SOURCE(S):

## DESCRIPTION OF DATA FILE: 
The purpose of this data file is to calculate the average distance from each municipality to the nearest cultural points (cultural center, art gallery, or museum).

## DESCRIPTION OF DATA MANIPULATION:
1) I loaded in cultural centers, art galleries, and museums and binded them together to create one cultural dataframe
3) I reprojected the cultural points, census tracts, and municipality dataframes into 103105 so that distances can be calculated in meaningful units
4) I created a dataframe of the tract centroids and then calculated the distance from each census tract centroid to the nearest cultural point
5) I converted the distance units into miles
6) I weighted the distance measure for each census tract according to the proportion of the census tract within the municipality
7) I aggregtated the distance at each census tract up to the municipal level

## KEY VARIABLE NAMES AND DEFINITIONS:
SSN: unique municipality identifier
average_distance: average distance (renamed when merging to average_d_cultural)

## LINK TO DESCRIPTIVE STATISTICS:
*Provide directory link to file with DS*

## DATA LIMITIONS:
None to my knowledge. The geocoded cultural center, art gallery, and museum points were sent to us from the UIC team. 

## COMMENTS/NOTES:  
I had originally had calculated the average distance from each cultural center, art gallery, and museum as opposed to binding them all into one dataframe, 
but Professor Kolak asked that we create one dataframe for all cultural points and calculate distance from there. 

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
*Including data citations with date data were downloaded and link, if available.*

