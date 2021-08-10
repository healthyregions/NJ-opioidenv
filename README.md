# NJ-opioidenv

## Git Structure
We will use the following standards for this github repo. 
+ code[folder]: Stores R scripts used to access, clean, and process data.
+ data_raw [folder]: Raw data pulled prior to processing
+ data_in_progress [folder]: Data files saved for futher processing
+ data_final[folder]:
    - geometryFiles [folder]: Stores geometry files
    - metadata [folder]: Stores metadata files as R markdown documents
    - cleaned, final data stored as CSV files.
- README [markdownfile]: Summarizes the structure and content of the directory

A copy of the cleaned final dataset, metdata document, and data dictionary will be added to the UChicago Box drive.

## Built Environment Measures By Domain:
The following domains were assigned to the UC team for collection. We will extract data for each variable construct and measure it as a specific geographic boundary for the entire state of NJ, using the most recent available data. At this time, we are mostly using Municipality (Tract level data obtained when available; County level data obtained when Tract/Municipality is not available) as the spatial scale.

### Quality of the Commercial Environment
| Variable Construct | Variable Proxy | Source(s) | Metadata Document | Spatial Scale | Status| Name in master |
|------------------ | -------------- | --------- | ----------------- | ------------- | ------ | --------------- |
| Business vacancy rates | Commercial vacancies| USPS quarterly vacancy reports | [USPS_VAC_2018](data_final/metadata/metadata_usps_vac_2018_variables.md) | Tract | Complete | foreclosure_rate, foreclosure_num |
| Numbers & types of businesses open for business | Number of businesses/municipality, percentage of businesses in municipality in each 2-digit NAICS classification code | UC library business data | [Business types](data_final/metadata/metadata_business_types.md) |Municipality  |Complete| business_vacancy_rate, prevalent_type |
| Number of Bars/Liquor stores (1,3) | Bars/Liquor store per capita and per area | Open Street Map | [Bars/Liquor stores](data_final/metadata/metadata_bars_liquorstores.md) |Municipality (Olina also calculated at smaller scales)  | Complete | ls_per_sqft |
| Transportation | No vehicles, % commuters via car and transit by household | ACS | [Residential Environment](data_final/metadata/metadata_residential_environment.md) |Tract   | Complete | no_vehicle, public_transit|

### Quality of the Residential Environment
| Variable Construct | Variable Proxy | Source(s) | Metadata Document | Spatial Scale | Status|Name in master |
|:------------------ | -------------- | --------- | ----------------- | ------------- | ----- | ------------- |
| Residential housing stock |  Multi-unit structures, mobile home percentage, crowded housing, % rental housing | Census/ACS | [Residential Environment](data_final/metadata/metadata_residential_environment.md) | Tract | Complete | multiunit_struct, mobile_home_rate, percent_renter
| Residential stability |  # households for over 20 yrs, Housing occupancy rate | Census/ACS | [Residential Environment](data_final/metadata/metadata_residential_environment.md) | Tract | Complete | num_households_20yrs, occupancy_rate
| Residential affordability |  average rent, high rent burden, average housing cost | Census/ACS | [Rent](data_final/metadata/metadata_rent.md) | Tract | Complete | median_rent, percent_housing_cost_burdened, median_home_value
| Residential conditions | residential vacancy rates (USPS 2018), home foreclosures (HUD 2009),  | multiple  | [Residential Environment](data_final/metadata/metadata_residential_environment.md) | Tract | Complete | vac_res, num_foreclosures
| Quality of public schools (9) | Data from walkscore captures the *quantity* of public schools | use school perf metric indicator from 2012 | [Walk Score](data_final/metadata/metadata_walkscore.md)  |Needs to be calculated (bin method or maybe count/pop??)  |In progress: depends on if we want quality or quantity  |


### Quality of the Physical Environment
| Variable Construct | Variable Proxy | Source(s) | Metadata Document | Spatial Scale | Status<br>(for Internal team use)| Name in Master |
|:------------------ | -------------- | --------- | ----------------- | ------------- | -------------------------------- | ------------- |
| Access to bike trails | Bike trails proxied with two OSM data measures (bikes trails and bikes trails + paths) which take ratio distance of bike trail <br> Note: [Braun et al. 2018](https://www.sciencedirect.com/science/article/pii/S096669231830930X) describes this measure (see section 3.3)/ municipality area  | OSM via osmdata package in R  | [Bike Lanes](data_final/metadata/metadata_bike_lanes.md) |Municipality | Complete | bike_path_ft_p_mile, bikes_ft_p_mile
| Walkability score  | Median and Mean walkscore | CSDS's copy of 2013 data from [Walkscore](https://www.walkscore.com) \ [2013 block group data](https://catalog.data.gov/dataset/tiger-line-shapefile-2013-state-new-jersey-current-block-group-state-based)| [Walk Score](data_final/metadata/metadata_walkscore.md)|Municipality | Complete | med_walk_score, mean_walk_score
| Zoning | percent of residential area that is high density, land use | [Rowan University Geodata Center](https://www.njmap2.com/landuse/landuse/) & [NJGIN Open data Portal](https://njogis-newjersey.opendata.arcgis.com/datasets/3d5d1db8a1b34b418c331f4ce1fd0fef_2)| [Physical Environment](data_final/metadata/metadata_physical_environment_2015.md)|Municipality | Complete | pct_h_den_res, pct_res_urb, pct_com_urb, pct_ind_urb
| Vegetation | NDVI | NASA Modis |[NDVI](data_final/metadata/metadata_ndvi.md)|Municipality | Complete | ndvi

### Health service availability

| Variable Construct | Variable Proxy | Source(s) | Metadata Document | Spatial Scale | Status<br>(for Internal team use)| Name in Master |
|------------------ | -------------- | --------- | ----------------- | ------------- | -------------------------------- | --------------- |
| Medication-assisted treatment & opioid treatment programs | |  |    |               |                                 | avg_MOUD_min_dist, MOUD_prop_under_10mi |
| Drug treatment programs |  |   |  | | *pending updated source (from UIC/Mark's team)| avg_SUT_min_dist |
| Syringe exchange programs |  |   |  | | data in box; needs updating | syringe_distance, syr_prop_under_10mi
| Mental health programs | Distance to nearest mental health provider | US Census, SAMSHA 2020  | Policy Scan/[Access: Mental Health Providers](data_final/metadata/Access_MentalHealth_MinDistance.md) |Tract, Zip | Complete | mental_hlt_dist

### Strength of community participation

| Variable Construct | Variable Proxy | Source(s) | Metadata Document | Spatial Scale | Status<br>(for Internal team use)| Name in Master  |
|:------------------ | -------------- | --------- | ----------------- | ------------- | -------------------------------- | --------------- |
| Religion Congregations per capita | Rates of adherence per 1,000 population |  [the Association of Religion Data Archive / U.S. Religion Census: Religious Congregations and Membership Study, 2010](https://www.thearda.com/Archive/Files/Descriptions/RCMSMT10.asp) | [Religious Congregations](data_final/metadata/metadata_religious_congregations.md) | Municipality (raw data available at the County level) | Complete | NA |
| Volunteerism per capita |  |   |  | | *pending updated source (from UIC team) | volunteer_opp
| Community; Adult Learning; Recreational Centers | Average distance to the nearest adult education program | [NJGIN Open Data](https://njogis-newjersey.opendata.arcgis.com/datasets/school-point-locations-of-nj-public-private-and-charter?geometry=-81.880%2C38.635%2C-67.564%2C41.575&orderBy=X)  | [Adult Learning](data_final/metadata/metadata_adult_ed_distance.md) | Municipality | Complete | adult_ed_distance
| Cultural Centers/Museum/Art Galleries | Average distance from each municipality to the nearest cultural points (cultural center, art gallery, or museum) | from the UIC team  | [Cultural distance](data_final/metadata/metadata_cultural_distance.md) | Municipality | Complete | cultural_dist

### Strength of community economy

| Variable Construct | Variable Proxy | Source(s) | Metadata Document | Spatial Scale | Status<br>(for Internal team use)| Name in Master
|:------------------ | -------------- | --------- | ----------------- | ------------- | -------------------------------- | ------- |
| Residential income per capita | income per capita | ACS  | [Community Economy](data_final/metadata/metadata_community_econ.md) | Tract | Complete | income_per_cap
| Residential employment per capita | employment per capita (unemployment may be a better measure?) | ACS  | [Community Economy](data_final/metadata/metadata_community_econ.md) |Tract | Complete | employment_per_cap
| Community investment |  |   |  | | *pending updated source (from UIC team) | NA


### Data Sources
The following sources were identified for each variable construct in the original proposal. Consider these starting points; we will identify the best available proxy for each variable construct. 

1. ESRI Business Analyst (Foreclosure Distressed Neighborhood Data) (https://www.arcgis.com/home/item.html?id=8d488e39958d44beab947fea62a18220).
2. Realty Trac Foreclosure Data (http://www.realtytrac.com/statsandtrends/foreclosuretrends/).
3. Open Street Map (https://www.openstreetmap.us/).
4. Department of Housing and Urban Development and US Census Bureau. American Housing Survey.
Washington, DC: US Census Bureau. 2012.
5. The Walk Score (walkscore.com).
6. Google Street View (GSV).
7. New Jersey MAP (NJ MAP) from the Geospatial Research Laboratory at Rowan University, New Jersey
8. Centers for Disease Control and Prevention/ Agency for Toxic Substances and Disease Registry/
 Geospatial Research, Analysis, and Services Program. Social Vulnerability Index Database US. 2014.
9. Neighborhood Scout (https://www.neighborhoodscout.com/nj/schools).
10. NewJerseyParkServiceTrails(https://data.nj.gov/).
11. US Geological Survey
12. The Association of Religion Data Archive (https://www.thearda.com/Archive/Files/Descriptions/RCMSMT10.asp)

