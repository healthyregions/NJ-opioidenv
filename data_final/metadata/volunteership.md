
# Dataset Name # 

- Meta Data Name: Average volunteership opportunities by municipality by month
- Date Last Modified: 7/29/2021
- Author: Christian Villanueva 
- Data File Name: volunteer_opp.csv
- Data Location: data_final

## DATA SOURCE(S):
https://www.jerseycares.org/
https://www.volunteermatch.org/search?l=NJ
Provided by UIC team

## DESCRIPTION OF DATA FILE: 
The purpose of this data file is to merge the average number of volunteer opportunities by municipality

## DESCRIPTION OF DATA MANIPULATION:
1) I merged the volunteerism document with another municipality level document to create NAs for the missing municipalities (approx 380)
2) I deleted all variables except for volunteerism and SSN
3) I converted all NAs to zeros
4) I merged to the master file

## KEY VARIABLE NAMES AND DEFINITIONS:
SSN: unique municipality identifier 
volunteer_opp: average number of volunteer opportunities by municipality by month

## LINK TO DESCRIPTIVE STATISTICS:
*Provide directory link to file with DS*

## DATA LIMITIONS:
Approximately 380 municiplaities had NAs that were reassigned to zeros after communiciation with UIC team. Because of the data generating process, we determined that an NA is effectively a zero.


## COMMENTS/NOTES:  
*Recommendations for how to use the data; ideas for future analyses or publications; record of relevant conversations about data* 

## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
*Including data citations with date data were downloaded and link, if available.*

