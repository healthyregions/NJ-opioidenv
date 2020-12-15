
# Dataset Name # 

- Meta Data Name: master
- Date Last Modified: 11/15/20
- Author: Gabriel Morrison
- Data File Name: master.csv, master_geog.geojson
- Programming File Name(s): create_master.R
- Data Location: data_final

## DATA SOURCE(S):
All data previously compiled

## DESCRIPTION OF DATA FILE: 
Compile all previously pulled data into one location


## DESCRIPTION OF DATA MANIPULATION:
For data already at municipality scale, the only manipulations conducted were to facilitate the data join. 

For data at the Census Tract scale, there were three main steps. First, I read the data in. Second, I made similar manipulations to facilitate the data joins (ie conversion of numeric to character).Third, I crosswalked the data using the crosswalk described in metadata_crosswalk from the census tract scale to the municipality scale. The key value provided by the crosswalk is that it provides rows each of which are either full census tracts or multiple rows that sum together to create one tract. They are separated when a census tract is divided in multiple municipalities. I joined this crosswalk to other data. Then, for each row of data, I multiplied that value by the percent its respective census tract in the municipality and then grouped (group_by) and summed (summarize(sum)) each of those values by municipality. 

Then the municipality data and crosswalked data were joined. This data was subsequently processed in the following ways. First, I added the area (using CRS 3424). I then removed columns that were percentages and were crosswalked and then recomputed them from the cross-walked "raw" data. I also computed rates for liquor stores/bars. 

Finally, this dataframe was written both spatially and non-spatially. 


## KEY VARIABLE NAMES AND DEFINITIONS:
Place.Name = The municipality (note that these are not unique)
SSN = Unique identifier for municipality
pop2016 = The 2014-2018 (most recent available) ACS population data 
area = The area in square feet of the municipality 
pct_h_d_res - percent of residential area that is high density 
pct_n_h_density_res - percent of residential area that is not high density 
pct_res_urb - percent of urban land in municipality that is residential of any kind
pct_com_urb - percent of urban land in municipality that is commercial 
pct_ind_urb -  percent of urban land in municipality that is industrial 
pct_res_tot - percent of total land in municipality that is residential of any kind
pct_com_tot - percent of total land in municipality that is commercial 
pct_ind_tot - percent of total land in municipality that is industrial  
med_walk_score - median walkscore from SSWS2USE
mean_walk_score - mean walkscore form SSWS2USE
num_schools - from Category 6 Flag (education). A count of the number of schools in the geographic area
bike_path_ft_p_mile - the number of miles of bike AND other paths summed per sq mile of municipality
bikes_ft_p_mile - the number of miles of bike paths alone summed per sq mile of municipality
count_bars - bars in municipality
count_ls - liquor stores in municipality
bars_per_sqft - number of bars divided by area of municipality        
bars_per_pop - number of bars divided by population of municipality (ACS 2018)
ls_per_sqft - number of liquor stores divided by area of municipality 
ls_per_pop - number of liquor stores divided by population of municipality (ACS 2018)
bars_ls_per_sqft - number of liquor stores and bars divided by area of municipality 
bars_ls_per_pop - number of liquor stores and bars divided by pop of municipality 
occupancy_rate: Occupance Rate
vacancy_rate: Vancancy Rate
mobile_home_rate: Mobile Home Percentage
multiunit_struct: Multi-Units Structure
pop_20yrs_plus: Population who have moved in for more than 20 years
pop_own_20yrs_plus: Homeowners who have moved in for more than 20 years
pop_ren_20yrs_plus: Renters who have moved in for more than 20 years
no_vehicle: Households with no vehicle available
public_transit: Means of transportation to work

see uspsmetadata for specifics on those columns

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

