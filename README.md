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
- Business foreclosure rates (1,2)
- Numbers & types of businesses open for business (1,3)
- Downtown conditions (1,4,5,6)
- Number of Bars/Liquor stores (1,3)
- Transportation (5,7)

### Quality of the Residential Environment
- Residential housing stock & market (1,4,8)
- Residential conditions (1,4,5,6)
- Quality of public schools (9)

### Quality of the Physical Environment
- Proportion of land used for industry (7)
- Proportion of commercial land use (7)
- Residential structure density (7)
- Proportion of land used for residence (5,6,10)

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

