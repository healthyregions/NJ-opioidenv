
# Dataset Name # 

- Meta Data Name: bike_lanes
- Date Last Modified: 11/18/20
- Author: Gabe Morrison
- Data File Name: bike_paths_mun.geojson
- Programming File Name(s): osm_bikes.R
- Data Location: data_in_progress

## DATA SOURCE(S):
Open Street Map via R's osmdata package; data downloaded Nov 19, 2020
NJGIN for municipalities shapefile

## DESCRIPTION OF DATA FILE: 
Goal is to compute a measure of bike lanes in each municipality


## DESCRIPTION OF DATA MANIPULATION:

### Step 1: Reading 
All data pulled using R's osmdata package/API
Pulled four different layers of OSM data within the New Jersey bounding box:
1. key = "bicycle"; value = "designated"
2. key = "highway"; value = "cycleway"
3. key = "highway"; value = "path"
4. key = "highway"; value = "footpath"

### Step 2: Combining query data
Combined the line attributes (osmlines) from each of these queries into two different sf objects. One included all four sets of data. The other included data from only the first two queries.

### Step 3: Compute Bike Lane/Path Length
Converted both bike lanes and bike lanes + paths to ESPG 3424.

Used st_length to compute the length of all bike lanes/paths.

### Step 4: Municipality Data Handling
Read in municipality spatial data (ESPG 3424) and filter to include only name, area (and geometry)

Created new sf objects that were centroids of line segments for both lanes and paths + lanes (to assign lines to municipalities)
Conducted spatial join to add municipality to centroid sf objects

### Step 5: Computing ratio of ft/mile
Created new sf objects that took the sum of the distance of the bike lanes + bike lanes and paths in each municipality
Joined that sf objects to municipality data (to get singular object with municipality path length and area)
Computed ratio of bike path/lane length/municipality area (ft/sq mile)

Joined the bike lane and bike lane and path dfs 

### Step 6: Write Data



## KEY VARIABLE NAMES AND DEFINITIONS:
bike_path_ft_p_mile - the number of miles of bike AND other paths summed per sq mile of municipality
bikes_ft_p_mile - the number of miles of bike paths alone summed per sq mile of municipality


## LINK TO DESCRIPTIVE STATISTICS:
Data in data_in_progress/bike_path_mun.geojson


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
