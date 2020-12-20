
nj_bus_mun 


- Meta Data Name: metadata_business_types
- Date Last Modified: 12/20/20
- Author: Gabriel Morrison
- Data File Name: data_in_progress/njbd2014.geojson and data_in_progress/nj_bus_mun2014.csv 
- Programming File Name(s): business_types.R
- Data Location: data_in_progress

## DATA SOURCE(S):
Unknown: Data from Marynia's box account

## DESCRIPTION OF DATA FILE: 
Takes data listing all businesses in the US and selected attributes about them and computes the following by municipality:
1. mean and median number of employees in a business
2. mean and median sales volume
3. the simpson index for employee size 
4. The number of businesses
5. The percentage of businesses that were in each 2-digit NAICS business classification


## DESCRIPTION OF DATA MANIPULATION:
Part 1:
The read the data, select only columns relevant to analysis, and filter out all non-New Jersey businesses.
Then write data from that process.
The data is written at this step because it takes the data from a text file to something usable which could be relevant for other/future analysis. 


Part 2 (organized by the functions this section calls):
clean_add_mun: remove unnecessary columns and spatial join to add municipality to each business (row)
bus_naics_count: count the total number of businesses in each municipality and the percent of each type
bus_size_emp: calculate the mean and median number of employees and sales size for each municipality

Joins dfs from the latter functions together

Part 3: 
Compute the Simpson Index for employee size for each municipality
Joins the this data to dfs calculated in part 2.


## KEY VARIABLE NAMES AND DEFINITIONS:
SSN - unique identifier for municipality 
mean_emp_size - mean employee size for each municipality
med_emp_size - median employee size for each municipality
mean_sales_vol - mean sales volume for each municipality
med_sales_vol - median sales volume for each municipality
simp_index_emp_size - simpson index for employee size for each municipality
all_bus - total count of businesses in each municipality
pct_naics_2 ... - the percent of businesses in each municipality that fall into the 2-digit NAICS classification system
pct_naics_2_NA - the percent of businesses that did not have a NAICS label 

## LINK TO DESCRIPTIVE STATISTICS:
data_in_progress/nj_bus_mun_2014.csv
data_in_progress/njbd2014.geojson

## DATA LIMITIONS:


Some businesses did not provide/were not given relevant information (employee size/NAICS categorization/sales volume) 
Also, one municipality lacked businesses evidently, given that the join found only 564 mnot 565 municipalities. 


## COMMENTS/NOTES:  
The script cleaning the data was written "functionally" which should allow for extremely easy replication with other data (eg 2018)

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
Unclear where initial data came from. 
Documentation for Simpson Index: https://www.rdocumentation.org/packages/vegan/versions/2.4-2/topics/diversity

