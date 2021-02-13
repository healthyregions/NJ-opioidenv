# NJ-opioidenv

## Git Structure
We will use the following standards for this github repo. 
+ code[folder]: Stores R scripts used to access, clean, and process data.
+ data_raw [folder]:raw data pulled prior to processing
+ data_final[folder]:
    - geometryFiles [folder]: Stores geometry files
    - metadata [folder]: Stores metadata files as R markdown documents
    - cleaned, final data stored as CSV files.
- README [markdownfile]: Summarizes the structure and content of the directory

A copy of the cleaned final dataset, metdata document, and data dictionary will be added to the UChicago Box drive.

## Built Environment Measures By Domain:
The following domains were assigned to the UC team for collection. We will extract data for each variable construct and measure it as a specific geographic boundary for the entire state of NJ, using the most recent available data. At this time, we'll likely use Municipalties as the spatial scale, but we're still deciding this.

### Quality of the Commercial Environment
| Variable Construct | Variable Proxy | Source(s) | Metadata Document | Spatial Scale | Status|
|:------------------ | -------------- | --------- | ----------------- | ------------- | -------------------------------- |
| Business vacancy rates | Commercial vacancies| USPS quarterly vacancy reports | [USPS_VAC_2018](data_final/metadata/metadata_usps_vac_2018_variables.md) | tract | Complete |
| Numbers & types of businesses open for business | Number of businesses/municipality, percentage of businesses in municipality in each 2-digit NAICS classification code | UC library business data | [business types](data_final/metadata/metadata_business_types.md) |Municipality  |Complete  |
| Number of Bars/Liquor stores (1,3) | Bars/Liquor store per capita and per area | Open Street Map | [Bars/Liquor stores](data_final/metadata/metadata_bars_liquorstores.md) |Municipality <br> Olina also calculated at smaller scales  | Complete |

### Quality of the Residential Environment
| Variable Construct | Variable Proxy | Source(s) | Metadata Document | Spatial Scale | Status|
|:------------------ | -------------- | --------- | ----------------- | ------------- | -------------------------------- |
| Residential housing stock |  Multi-unit structures, mobile home percentage, crowded housing, % rental housing | Census/ACS | [Residential Environment](data_final/metadata/metadata_residential_environment.md) | Tract | Complete |
| Residential stability |  # households for over 20 yrs, Housing occupancy rate | Census/ACS | [Residential Environment](data_final/metadata/metadata_residential_environment.md) | Tract | Complete |
| Residential affordability |  average rent, high rent burden, average housing cost | Census/ACS |  | | |
| Residential conditions | residential vacancy rates (USPS 2018), home foreclosures (HUD 2009),  | multiple  | [Residential Environment](data_final/metadata/metadata_residential_environment.md) | Tract | Complete |
| Quality of public schools (9) | Data from walkscore captures the *quantity* of public schools | use school perf metric indicator from 2012 | [Walk Score](data_final/metadata/metadata_walkscore.md)  |Needs to be calculated (bin method or maybe count/pop??)  |In progress: depends on if we want quality or quantity  |
| Transportation | no vehicles, % commuters via car and transit by household | ACS | [Residential Environment](data_final/metadata/metadata_residential_environment.md) |Tract   | In Progress |

### Quality of the Physical Environment
| Variable Construct | Variable Proxy | Source(s) | Metadata Document | Spatial Scale | Status<br>(for Internal team use)|
|:------------------ | -------------- | --------- | ----------------- | ------------- | -------------------------------- |
| Access to bike trails | Bike trails proxied with two OSM data measures (bikes trails and bikes trails + paths) which take ratio distance of bike trail <br> Note: [Braun et al. 2018](https://www.sciencedirect.com/science/article/pii/S096669231830930X) describes this measure (see section 3.3)/ municipality area  | OSM via osmdata package in R  | [Bike Lanes](data_final/metadata_bike_lanes.md) |Municipality | Complete |
| Walkability score  |  | CSDS's copy of 2013 data from [Walkscore](https://www.walkscore.com) [2013 block group data](https://catalog.data.gov/dataset/tiger-line-shapefile-2013-state-new-jersey-current-block-group-state-based)| [Walk Score](data_final/metadata_walkscore.md)|Municipality | Complete |
| Zoning |  | [Rowan University Geodata Center](https://www.njmap2.com/landuse/landuse/) & [NJGIN Open data Portal](https://njogis-newjersey.opendata.arcgis.com/datasets/3d5d1db8a1b34b418c331f4ce1fd0fef_2)| [Physical Environment](data_final/metadata_physical_environment_2015.md)|Municipality | Complete |
| Vegetation | NDVI | NASA Modis | | |  |

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

