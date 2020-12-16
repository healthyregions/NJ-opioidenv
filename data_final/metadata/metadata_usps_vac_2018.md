
# Dataset Name # 

- Meta Data Name: usps_vac_2018
- Date Last Modified: 12/12/20
- Author: Fanmei Xia
- Data File Name: usps_vac_2018
- Programming File Name(s): usps_vac_2018.csv
- Data Location: data_in_progress

## DATA SOURCE(S):
USPS; data last accessed Nov 20, 2020

## DESCRIPTION OF DATA FILE: 
Find proxies to construct business/residential conditions in New Jersey


## DESCRIPTION OF DATA MANIPULATION:

### Step 1: Reading 
All data downloaded from USPS website
Check for available variables in the USPS dictionary

Pulled tract level data of New Jersey:
#### identify variables from AMS: Total Count of Addresses 
  1. Residential: AMS_RES           	
  2. Business: AMS_BUS	
  3. Other: AMS_OTH

#### identify variables from VAC: Total Count of Vacant Addresses 
  1. RES_VAC:    Total Count of Vacant Addresses - Residential
  2. BUS_VAC:    Total Count of Vacant Addresses - Business
  3. OTH_VAC:    Total Count of Vacant Addresses - Other

#### identify variables from AVG_VAC
  1. AVG_VAC_R: Average Days Addresses Vacant - Residential
  2. AVG_VAC_B: Average Days Addresses Vacant - Business

#### identify variables from VAC_by_month
 1. VAC_3_RES: Vacant 3 Mos. to Less Count - Residential
 2. VAC_3_BUS: Vacant 3 Mos. to Less Count - Business
 3. VAC_3_OTH: Vacant 3 Mos. to Less Count - Other
 4. VAC_3_6_R: Vacant 3 Mos. to 6 Mos. Count - Residential
 5. VAC_3_6_B: Vacant 3 Mos. to 6 Mos. Count - Business
 6. VAC_3_6_O: Vacant 3 Mos. to 6 Mos. Count - Other
 7. VAC_6_12R: Vacant 6 Mos. to 12 Mos. Count - Residential
 8. VAC_6_12B: Vacant 6 Mos. to 12 Mos. Count - Business
 9. VAC_6_12O: Vacant 6 Mos. to 12 Mos. Count - Other
 10. VAC_12_24R: Vacant 12 Mos. to 24 Mos. Count - Residential
 11. VAC_12_24B: Vacant 12 Mos. to 24 Mos. Count - Business
 12. VAC_12_24O: Vacant 12 Mos. to 24 Mos. Count - Other
 13. VAC_24_36R: Vacant 24 Mos. to 36 Mos. Count - Residential
 14. VAC_24_36B: Vacant 24 Mos. to 36 Mos. Count - Business
 15. VAC_24_36O: Vacant 24 Mos. to 36 Mos. Count - Other
 16. VAC_36_RES: Vacant 36 Mos. or Longer Count - Residential
 17. VAC_36_BUS: Vacant 36 Mos. or Longer Count - Business
 18. VAC_36_OTH: Vacant 36 Mos. or Longer Count - Other

#### identify variables from PQV
 1. PQV_IS_RES Previous Qtr Vacant Currently In Service Count – Residential
 2. PQV_IS_BUS Previous Qtr Vacant Currently In Service Count – Business
 3. PQV_IS_OTH Previous Qtr Vacant Currently in Service Count - Other
 4. PQV_NS_RES Previous Qtr Vacant Currently No-Stat Count – Residential
 5. PQV_NS_BUS Previous Qtr Vacant Currently No-Stat Count – Business
 6. PQV_NS_OTH Previous Qtr Vacant Currently No-Stat Count – Other

#### identify variables from NO_STAT
 1. NOSTAT_RES Total Count of No-Stat Addresses - Residential
 2. NOSTAT_BUS Total Count of No-Stat Addresses - Business
 3. NOSTAT_OTH Total Count of No-Stat Addresses - Other
 4. AVG_NS_RES Average Days Addresses No-Stat - Residential
 5. AVG_NS_BUS Average Days Addresses No-Stat - Business
 6. NS_3_RES No-Stat 3 Mos. to Less Count - Residential
 7. NS_3_BUS No-Stat 3 Mos. to Less Count - Business
 8. NS_3_OTH No-Stat 3 Mos. to Less Count - Other
 9. NS_3_6_RES No-Stat 3 Mos. to 6 Mos. Count - Residential
 10. NS_3_6_BUS No-Stat 3 Mos. to 6 Mos. Count - Business
 11. NS_3_6_OTH No-Stat 3 Mos. to 6 Mos. Count - Other
 12. NS_6_12_R No-Stat 6 Mos. to 12 Mos. Count - Residential
 13. NS_6_12_B No-Stat 6 Mos. to 12 Mos. Count - Business
 14. NS_6_12_O No-Stat 6 Mos. to 12 Mos. Count - Other
 15. NS_12_24_R No-Stat 12 Mos. to 24 Mos. Count - Residential
 16. NS_12_24_B No-Stat 12 Mos. to 24 Mos. Count - Business
 17. NS_12_24_O No-Stat 12 Mos. to 24 Mos. Count - Other
 18. NS_24_36_R No-Stat 24 Mos. to 36 Mos. Count - Residential
 19. NS_24_36_B No-Stat 24 Mos. to 36 Mos. Count - Business
 20. NS_24_36_O No-Stat 24 Mos. to 36 Mos. Count - Other
 21. NS_36_RES No-Stat 36 Mos. or Longer Count - Residential
 22. NS_36_BUS No-Stat 36 Mos. or Longer Count - Business
 23. NS_36_OTH No-Stat 36 Mos. or Longer Count - Other
 24. PQNS_IS_R Previous Qtr No-Stat Currently In Service Count – Residential
 25. PQNS_IS_B Previous Qtr No-Stat Currently In Service Count – Business
 26. PQNS_IS_O Previous Qtr No-Stat Currently In Service Count – Other

### Step 2: Compute Occupance/Vancancy Rate
 
 tbd

### Step 3: Write Data


## KEY VARIABLE NAMES AND DEFINITIONS



## LINK TO DESCRIPTIVE STATISTICS:
Data in data_in_progress/usps_vac_2018.cvs


## DATA LIMITIONS: 


## COMMENTS/NOTES:  
 



## ACKNOWLEDGEMENTS:  
This project is supported by the National Institute of Drug Abuse at the National Institutes of Health (R21 DA046739-01A1; Developing a public health measure of built environment to assess risk of nonmedical opioid use and related mortality in urban and non-urban areas in New Jersey). 

## REFERENCES:
https://www.huduser.gov/portal/usps/home.html

