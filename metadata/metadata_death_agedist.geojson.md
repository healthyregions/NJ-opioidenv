# Dataset Name # 

- Meta Data Name: geojson file containing accidental opioid overdose death counts by year, age adjusted rate by year, percent change by year, and a binary measure of increase/decrease in deaths by year
- Date Last Modified: 7/20/2021
- Author: Christian Villanueva
- Data File Name: death_agedist.geojson
- Programming File Name(s):
- Data Location: data_final

## DATA SOURCE(S):
US Census/ACS used for population age information, death data collected from New Jersey Medical Examiner's Office and cleaned by Emily Selch

## DESCRIPTION OF DATA FILE: 
The purpose of this dataset is to calculate death rates, and changes over time in New Jersey Municipalities

## DESCRIPTION OF DATA MANIPULATION:
1) Data provided at individual level
2) Data spatially joined and aggregated at municipal level
3) Data collected from US census/ACS - totaled all individuals in most recent ACS Report in age group 15-64 years old
4) age adjusted rates calculated
5) Percent change calculated (0 deaths to 0 deaths coded as no change, change from 0 deaths to higher/lower counted as NA)
6) Binary change calculated (increase , decrease, or no change from year to year coded as 1, -1, 0 respectively)


## KEY VARIABLE NAMES AND DEFINITIONS:
SSN: unique municipality identifier 
MUN: Municipality Abbreviation
County: County Name
MUN_LABEL: Municiaplity Name
dtC2015: total deaths 2015
dtC2016: total deaths 2016
dtC2017: total deaths 2017
dtC2018: total deaths 2018
rAll: total death rate 2015-2018
r2015: death rate 2015
r2016: death rate 2016
r2017: death rate 2017
r2018: death rate 2018
pctCh1516: percent change in death rate from 2015-2016
pctCh1617: percent change in death rate from 2016-2017
pctCh1618: percent change in death rate from 2017-2018
pctCh1518: percent change in death rate from 2015-2018
change16: binary increase/decrease/no change in death rate 2015-2016
change17: binary increase/decrease/no change in death rate 2017-2017
change18: binary increase/decrease/no change in death rate 2016-2018
changeall: binary increase/decrease/no change in death rate 2015-2018


## LINK TO DESCRIPTIVE STATISTICS:
*Provide directory link to file with DS*

## DATA LIMITIONS:
None to my knowledge.

## COMMENTS/NOTES:  
*Recommendations for how to use the data; ideas for future analyses or publications; record of relevant conversations about data* 

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
*Including data citations with date data were downloaded and link, if available.*

