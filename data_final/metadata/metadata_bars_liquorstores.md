
# Dataset Name # 

- Meta Data Name: Bars and Liquor stores in New Jersey
- Date Last Modified: Nov. 30, 2020
- Author: Yingyi (Olina) Liang
- Data File Name: nj_bars_liquorstores_sum.geojson
- Programming File Name(s): osm_alcohol.Rmd
- Data Location: data_in_progress

## DATA SOURCE(S):
Open Street Map (data downloaded Nov 30, 2020)

## DESCRIPTION OF DATA FILE: 
Municipality level bars/liquor stores per capita and per area.

## DESCRIPTION OF DATA MANIPULATION:
Bars/liquor stores data downloaded from OpenStreetMap using R. <br />
Tract-level shapefile from https://catalog.data.gov/dataset/tiger-line-shapefile-2019-state-new-jersey-current-census-tract-state-based<br />
Population data from https://www2.census.gov/geo/docs/reference/cenpop2010/tract/CenPop2010_Mean_TR34.txt<br />
1. Extract locations of all bars/liquor stores inside NJ bounds using *osmdata* package.
2. Combine shapefile with population file.
3. Join shapefile with bars/liquor stores file and count number in each tract.

## KEY VARIABLE NAMES AND DEFINITIONS:
GEOID: STATEFP+COUNTYFP+TRACTCE <br />
tract_area: area of tract in m^2<br />
population: population of tract<br />
n_bars: number of bars in tract<br />
bars_per_area_km2: bars per area in km^2<br />
bars_per_capita: n_bars/population<br />
n_liquorstores: number of liquor stores in tract<br />
liquorstores_per_area_km2: liquor stores per area in km^2<br />
liquorstores_per_capita: n_liquorstores/population<br />
geometry: shape of tract

## LINK TO DESCRIPTIVE STATISTICS:
data_in_progress/nj_bars_liquorstores_sum.geojson

## DATA LIMITIONS:
/

## COMMENTS/NOTES:  
/

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
[OSM wiki - bars](https://wiki.openstreetmap.org/wiki/Tag:amenity%3Dbar) <br>
[OSM wiki - alcohol shop](https://wiki.openstreetmap.org/wiki/Tag:shop%3Dalcohol)

