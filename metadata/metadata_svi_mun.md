
# svi_mun.csv # 

- Meta Data Name: metadata_svi_mun
- Date Last Modified: 04/22/2021
- Author: Fanmei Xia
- Data File Name: svi_mun.csv
- Programming File Name(s): code/svi_mun.rmd
- Data Location: data_final

## DATA SOURCE(S):
- sent from the UIC team (box folder)
- also accessible directly from the CDC website:
https://www.atsdr.cdc.gov/placeandhealth/svi/data_documentation_download.html

## DESCRIPTION OF DATA FILE: 
*What is the rationale or purpose of the data?*
ATSDR’s Geospatial Research, Analysis & Services Program (GRASP) created Centers for Disease Control and Prevention Social Vulnerability Index (CDC SVI or simply SVI, hereafter) to help public health officials and emergency response planners identify and map the communities that will most likely need support before, during, and after a hazardous event.

SVI indicates the relative vulnerability of every U.S. Census tract. Census tracts are subdivisions of counties for which the Census collects statistical data. SVI ranks the tracts on 15 social factors, including unemployment, minority status, and disability, and further groups them into four related themes. Thus, each tract receives a ranking for each Census variable and for each of the four themes, as well as an overall ranking.

For the purpose of the current study, we only used the SVI2018 data file, and manupulated it to municipality level. The original dataset at the tract level can be found in the data_raw folder (SVI-NewJersey2018.csv). In the orginal data file, in addition to tract-level rankings, SVI2018 also have corresponding rankings at the county level. Notes below that describe “tract” methods also refer to county methods.

## DESCRIPTION OF DATA MANIPULATION:
*How were data modified? How were key variables calculated and used?*

Step 1: clean missing data
•	Tracts with zero estimates for total population (N = 645 for the U.S.) were removed during the ranking process. These tracts were added back to the SVI databases after ranking. The TOTPOP field value is 0, but the percentile ranking fields (RPL_THEME1, RPL_THEME2, RPL_THEME3, RPL_THEME4, and RPL_THEMES) were set to NA.
•	For tracts with > 0 TOTPOP, a value of NA in any field either means the value was unavailable from the original census data or we could not calculate a derived value because of unavailable census data.
•	Any cells with a NA were not used for further calculations.

Step 2: read in the interpolation file
•	Since we later need to merge with the master dataset, we need to interpolate the data from tract to municipality level.

Step 3: merge with the interpolation file
•	I updated the svi SPL and RPL values to calculate what percent of the municipality each fragment of the census tract constituted. That is, if a census tract was entirely in one municipality and its area constituted 50% of the municipality, it will also contribute 0.5 of the original SPL/RPL value to the corresponding municipality.

## KEY VARIABLE NAMES AND DEFINITIONS:
Place.Name: County name
SSN: County code (used to merge datasets)
SPL_THEME1:	Sum of series for Socioeconomic theme
RPL_THEME1:	Percentile ranking for Socioeconomic theme summary
SPL_THEME2	Sum of series for Household Composition theme
RPL_THEME2	Percentile ranking for Household Composition theme summary
SPL_THEME3	Sum of series for Minority Status/Languag e theme
RPL_THEME3	Percentile ranking for Minority Status/Language theme
SPL_THEME4	Sum of series for Housing Type / Transportation theme
RPL_THEME4	Percentile ranking for Housing Type / Transportation theme
SPL_THEMES	Sum of series themes
RPL_THEMES	Overall percentile ranking

## LINK TO DESCRIPTIVE STATISTICS:
*Provide directory link to file with DS*

## DATA LIMITIONS:
*Data quality? Missing data and how it was dealt with? List geographic areas and years where data are problematic and how corrected.*
When replicating SVI using Microsoft Excel or similar software, results may differ slightly from databases on the SVI website or ArcGIS Online. This is due to variation in the number of decimal places used by the different software programs. For purposes of automation, we developed SVI using SQL programming language. Because the SQL programming language uses a different level of precision compared to Excel and similar software, reproducing SVI in Excel may marginally differ from the SVI databases downloaded from the SVI website. For future iterations of SVI, beginning with SVI 2018, we plan to modify the SQL automation process for constructing SVI to align with that of Microsoft Excel. If there are any questions, please email the SVI Coordinator at svi_coordinator@cdc.gov.

## COMMENTS/NOTES:  
*Recommendations for how to use the data; ideas for future analyses or publications; record of relevant conversations about data* 

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
*Including data citations with date data were downloaded and link, if available.*
CDC website:
https://www.atsdr.cdc.gov/placeandhealth/svi/index.html

