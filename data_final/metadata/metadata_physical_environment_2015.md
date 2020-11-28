
# Physical Environment 2015 # 

- Meta Data Name: meta_data_physical_environment_2015
- Date Last Modified: November 2, 2020
- Author: Gabriel Morrison 
- Data File Name: physical_environment_2015 (.geojson)
- Programming File Name(s): cleaning_land_use.R, municipality_clean.R
- Data Location: NJ-opioidenv/data_in_progress

## DATA SOURCE(S): 
(1) *Rowan University Geodata Center* https://www.njmap2.com/landuse/landuse/
(2) *NJGIN Open data Portal* https://njogis-newjersey.opendata.arcgis.com/datasets/3d5d1db8a1b34b418c331f4ce1fd0fef_2

## DESCRIPTION OF DATA FILE: 
This data summarizes land use (commercial, residential, industrial) by municipality 


## DESCRIPTION OF DATA MANIPULATION:

*cleaning_land_use.R*
Part 1: Remove unnecessary columns, convert to correct types from data Rowan University Data
Part 2 a: Create a new dataframe measuring percentage of residential, commercial, and industrial out of all urban land and all land 
Part 2 b: Creates a new dataframe that measures municiaplities' percentages of high and low density residential areas (ie high density residential area/total residential area)
Part 2 c: joins the above two dataframes together 
Part 3: physical environment data joined to municipality spatial data and written as .geojson

*municipality_clean.R*
Reads shapefile NJGIN
Removes unnecessary columns
using ms_simplify, simplifies the polygons by removing 75% of their points. This does not change the general appearance of the spatial data
writes file as .geojson 

## KEY VARIABLE NAMES AND DEFINITIONS:
Place.ID - municipality ID (numeric)
Place.Name - municipality (string)
pct_h_d_res - percent of residential area that is high density 
pct_n_h_density_res - percent of residential area that is not high density 
pct_res_urb - percent of urban land in municipality that is residential of any kind
pct_com_urb - percent of urban land in municipality that is commercial 
pct_ind_urb -  percent of urban land in municipality that is industrial 
pct_res_tot - percent of total land in municipality that is residential of any kind
pct_com_tot - percent of total land in municipality that is commercial 
pct_ind_tot - percent of total land in municipality that is industrial  

## LINK TO DESCRIPTIVE STATISTICS:

data_in_progress/physical_environment_2015.geojson


## DATA LIMITIONS:
Data is only from 2015
Note that proportions do not sum to 100% or 1 because there are other land uses not included. For example, land devoted to transportation is excluded.
The measures of industry include classifications both of industry themselves and of "Industrial and Commerical complexes). 


## COMMENTS/NOTES:  
Based on visualizations in Vis_pe2015.Rmd (in /code), Gabe recommends using the "of urban" measures because they, on the whole, are likely less skewed and they give a better representation of the urban environment. In other words, they exclude "natural" regions from the assessment. 

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
https://www.njmap2.com/landuse/landuse/
Downloaded October of 2020

https://njogis-newjersey.opendata.arcgis.com/datasets/3d5d1db8a1b34b418c331f4ce1fd0fef_2
Downloaded October of 2020

