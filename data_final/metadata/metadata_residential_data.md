
# Dataset Name # 

- Meta Data Name: residential_data
- Date Last Modified: 11/29/20
- Author: Fanmei Xia
- Data File Name: residential_data
- Programming File Name(s): residential_data.Rmd
- Data Location: data_in_progress

## DATA SOURCE(S):
Census/ACS; data last accessed Nov 29, 2020

## DESCRIPTION OF DATA FILE: 
Find proxies to construct residential conditions in New Jersey


## DESCRIPTION OF DATA MANIPULATION:

### Step 1: Reading 
All data pulled using R's package/API
Check for available variables in the census data (in this case American Community Survey)

Pulled tract level data of New Jersey:
#### identify variables from B25002: OCCUPANCY STATUS
  1. Total Units           B25002_001 Estimate!!Total	
  2. Occupancy : Occupied  B25002_002 Estimate!!Total!!Occupied	
  3. Occupancy : Vacant    B25002_003 Estimate!!Total!!Vacant	

#### identify variables from B25024: UNITS IN STRUCTURE
  1. Type : Mobile home    B25024_010	Estimate!!Total!!Mobile home, Base B25024_001 should be same as B25002_001
  2. Type : Multi-units-2    B25024_004	Estimate!!Total!!2
  3. Type : Multi-units-3or4    B25024_005		Estimate!!Total!!3 or 4
  4. Type : Multi-units-5to9    B25024_006		Estimate!!Total!!5 to 9	
  5. Type : Multi-units-10-19    B25024_007		Estimate!!Total!!10 to 19
  6. Type : Multi-units-20-49    B25024_008		Estimate!!Total!!20 to 49
  7. Type : Multi-units-50+    B25024_009		Estimate!!Total!!50 or more

#### identify variables from B25003 : TENURE
  1. Status: Occupied        B25003_001 Estimate!!Total	Occupied Units
  2. Status: Owner Occupied  B25003_002 Estimate!!Total!!Owner occupied Units
  3. Status: Renter Occupied B25003_003 Estimate!!Total!!Renter occupied Units

#### identify variables from B08201 : HOUSEHOLD SIZE BY VEHICLES AVAILABLE
 1. Type: No Vehicle Available B08201_002 Estimate!!Total!!No vehicle available

#### identify variables from B08301 : MEANS OF TRANSPORTATION TO WORK
 1. Type: Public Transportation B08301_010 	Estimate!!Total!!Public transportation (excluding taxicab)

#### identify variables from B25026: TOTAL POPULATION IN OCCUPIED HOUSING UNITS BY TENURE BY YEAR HOUSEHOLDER MOVED INTO UNIT
  1. Year : Tot Pop   OwnOcc B25026_002 Estimate!!Total population in occupied housing units!!Owner occupied	
  2. Year : 1990_1999 OwnOcc B25026_007 Estimate!!Total population in occupied housing units!!Owner occupied!!Moved in 1990 to 1999
  3. Year : <1989     OwnOcc B25026_008 Estimate!!Total population in occupied housing units!!Owner occupied!!Moved in 1989 or earlier	
  4. Year : Tot Pop   RenOcc B25026_009	Estimate!!Total population in occupied housing units!!Renter occupied	
  5. Year : 1990_1999 RenOcc B25026_014 Estimate!!Total population in occupied housing units!!Renter occupied!!Moved in 1990 to 1999	
  6. Year : <1989     RenOcc B25026_015 Estimate!!Total population in occupied housing units!!Renter occupied!!Moved in 1989 or earlier

### Step 2: Compute Occupance/Vancancy Rate, Mobile Home Percentage, Multi-Units Structure, Population who have moved in for more than 20 years
occupancy_rate = occupied_units/total_units, 
vacancy_rate = vacant_units/total_units,
mobile_home_rate = mobile_home/total_units,
multiunit_struct = multiunits_two + multiunits_three_or_four + multiunits_five_to_nine + multiunits_10_to_19 + multiunits_20_to_49 + multiunits_50plus,
pop_own_20yrs_plus = pop_own_90_99 + pop_own_bfr89,
pop_ren_20yrs_plus = pop_ren_90_99 + pop_ren_bfr89,
pop_20yrs_plus = pop_own_20yrs_plus + pop_ren_20yrs_plus

### Step 3: Write Data


## KEY VARIABLE NAMES AND DEFINITIONS:

occupancy_rate: Occupance Rate
vacancy_rate: Vancancy Rate
mobile_home_rate: Mobile Home Percentage
multiunit_struct: Multi-Units Structure
pop_20yrs_plus: Population who have moved in for more than 20 years
pop_own_20yrs_plus: Homeowners who have moved in for more than 20 years
pop_ren_20yrs_plus: Renters who have moved in for more than 20 years
no_vehicle: Households with no vehicle available
public_transit: Means of transportation to work

## LINK TO DESCRIPTIVE STATISTICS:
Data in data_in_progress/residential_data.Rmd


## DATA LIMITIONS: 
Given that Open Street Map (OSM) is a collaborate, open source data source, its OSM's data is inherently limited. Bike lanes are difficult to pick out given that they can be classified reasonably in a number of different ways. I suspect that the bikes only data source created here underestimates the total bike lanes in New Jersey while the bike lanes and paths picks up on some footpaths that are not intended for bike use (OSM Highway Path Wiki). That said, Ferster et al. 2019 uses the three key = highway queries above, and key = bicycle value = designated is also highly intuitive to select bike lanes (see OSM Bicycle wiki). 

See Ferster et al. 2019 (linked below). 

## COMMENTS/NOTES:  
The bike_ft_p_mile better captures only bike lanes but may not assess all bike lanes in NJ, but bike_path_ft_p_mile likely overestimates this measure by including some paths that are not "bikeable." 



## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
OSM: https://www.openstreetmap.org/#map=4/38.01/-95.84
osmdata (R package): https://cran.r-project.org/web/packages/osmdata/vignettes/osmdata.html
Ferster et al. 2019: https://www.researchgate.net/publication/331293632_Using_OpenStreetMap_to_inventory_bicycle_infrastructure_A_comparison_with_open_data_from_cities
OSM Highway Path Wiki: https://wiki.openstreetmap.org/wiki/Tag:highway%3Dpath
OSM Bicycle Wiki: https://wiki.openstreetmap.org/wiki/Bicycle
