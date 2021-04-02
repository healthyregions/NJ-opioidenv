
# Dataset Name # 

- Meta Data Name: NDVI
- Date Last Modified: 02/13/2020
- Author: Emily Selch
- Data File Name: municipal_ndvi.csv
- Programming File Name(s): 
- Data Location: 

## DATA SOURCE(S):
All data came from the US Geological Survey through their EarthExplorer product.

## DESCRIPTION OF DATA FILE: 
The data file describes the average NDVI for each municipality in NJ over the course of the summer months in 2018 (May 29, 2018 - September 3, 2018).  

## DESCRIPTION OF DATA MANIPULATION:
USGS puts out a .tif image for every 6-day period, which I downloaded from their website. I specified the period of time, navigated to "Vegetation Monitoring," and selected eMODIS NDVI V6. I loaded each of these .tif images (14 images) into my R environment, calculated an average for each raster, cropped the averaged image to a reprojected municipal shapefile (reprojected to the USGS projection), masked the cropped image to the reprojected shapefile, extracted the data, and then merged it to the municipal shapefile. I then removed the spatial data and saved the file as a .csv.  

## KEY VARIABLE NAMES AND DEFINITIONS:
municipality = municiaplity name
ndvi = ndvi

## LINK TO DESCRIPTIVE STATISTICS:
*Provide directory link to file with DS*

## DATA LIMITIONS:
In the interest of time and space on my hardrive, I only downloaded .tif images for the summer months or, rather, the greenest months. Any NDVI estimates will be most pronounced during these months.   

## COMMENTS/NOTES:  
The data has been merged to the master municipal shapefile to help build out the index.  

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
https://earthexplorer.usgs.gov/
