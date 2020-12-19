#Business Measures

#Load Packages:
library(tidyverse)
library(tidylog)
library(sf)
library(data.table)
library(tmap)


#PART 1: GETTING A USABLE df/sf object ========
#Prep for getting documents
#Note: here I read the data with 1 row and then extracted column type. I used that in the fread/colClasses call  
  bdhead <- fread("data_raw/2014_Business_Academic_QCQ.txt",
                  nrows = 20)
  #names_of_cols2 <- sapply(bdhead, class)


#Read Data:
bd <- fread("data_raw/2014_Business_Academic_QCQ.txt", 
            colClasses=c(
              "logical"     ,             "character" ,
              "character"   ,              "character" ,
              "logical"     ,               "logical" ,
              "logical"      ,              "integer" ,
              "integer"       ,           "character" ,
              "character"      ,              "integer", 
              "character"       ,             "integer" ,
              "character"        ,            "NULL" ,
              "NULL"              ,      "NULL" ,
              "NULL"               ,     "NULL" ,
              "NULL"                ,    "NULL" ,
              "NULL"                 ,   "NULL" ,
              "NULL"                 ,   "integer" ,
              "NULL"                 ,   "integer", 
              "integer"              ,      "integer", 
              "character"            ,        "NULL", 
              "boolean"                 ,   "NULL" ,
              "integer"              ,      "NULL" ,
              "NULL"                 ,   "NULL" ,
              "NULL"                 ,   "NULL" ,
              "NULL"                 ,   "NULL" ,
              "NULL"                 ,   "NULL" ,
              "NULL"                 ,   "NULL" ,
              "logical"              ,      "logical", 
              "logical"              ,      "logical" ,
              "logical"              ,      "logical" ,
              "logical" ), 
            showProgress = TRUE)

       
njbd1 <- bd[State == "NJ"]

njbd <- njbd1 %>%
  as.data.frame() %>%
  st_as_sf(coords = c("Longitude", "Latitude"))

#Writing njbd:
#Note: njbd dataframe will be place where all data can be acquired from for project in future.
#I will continue analyzing a subset of njbd with fewer columns. 

st_write(njbd, "data_in_progress/njbd.geojson")

## PART 2: SIMPLIFY DF AND CREATE COUNT FOR 2 DIGIT NAICS BY MUNICIPALITY ======

#Read Data Previously Written:
njbd <- st_read("data_in_progress/njbd.geojson")

#Bring in municipality data for spatial join:
mun <- st_read("data_in_progress/mun_boundaries.geojson") %>%
  select(SSN) %>%
  st_transform(3424)

nj_bus <- njbd %>%
  select(Company, naics9 = Primary.NAICS.Code, sales_volume = Sales.Volume..9....Location, 
         emp_size = Employee.Size..5....Location, office_size = Office.Size.Code) %>% #grab useful columns
  mutate(naics_2 = str_sub(naics9, start = 1L, end = 2L)) %>% #Create column with naics2 codes
  #st_set_crs(3424) %>% #Names crs
  st_transform(crs = st_crs(mun)) %>% #Actually sets crs
  st_join(mun) %>%#Adds municipality via spatial join
  as.data.frame() %>% #Converts to dataframe
  select(-geometry) #Removes geometry column; should be faster


#This df captures counts of all counts of businesses and percentage of each naics2 classification (specific type/total businesses in mun)
nj_bus_naics <- nj_bus %>%
  group_by(SSN, naics_2) %>% #shapes df to unique SSn and naics2
  summarize(n = n()) %>% #counts the number of naics2 in each ssn
  mutate(naics_2 = as.character(naics_2)) %>% 
  mutate(naics_2 = paste0("pct_naics_2_", naics_2)) %>% #Renames naics2 to pct_naics_2_{naicscode} 
  pivot_wider(names_from = naics_2, values_from = n, values_fill = 0) %>% #Reshapes to organize by mun
  mutate(all_bus = rowSums(across(pct_naics_2_21:pct_naics_2_NA))) %>% #Gets new column with sum of all businesses in the mun
  mutate(across(pct_naics_2_21:pct_naics_2_NA, {~.x / all_bus})) #Converts rows from counts to percent 
  



#This df captures mean and median employment size and sales volume
nj_bus_size_emp <- nj_bus %>%
  group_by(SSN) %>%
  summarize(mean_emp_size = mean(emp_size, na.rm = TRUE), 
            med_emp_size = median(emp_size, na.rm = TRUE),
            mean_sales_vol = mean(sales_volume, na.rm = TRUE),
            med_sales_vol = median(sales_volume, na.rm = TRUE)
  )

nj_bus_mun <- left_join(nj_bus_naics, nj_bus_size_emp)


#Write Data:
write.csv(nj_bus_mun, "data_in_progress/nj_bus_mun.csv")
  

