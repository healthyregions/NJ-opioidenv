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
                  nrows = 1)
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
              "NULL"                 ,   "NULL" ,
              "NULL"                 ,   "integer", 
              "integer"              ,      "integer", 
              "character"            ,        "NULL", 
              "NULL"                 ,   "NULL" ,
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
  st_as_sf(coords = c("Latitude", "Longitude"))

#Writing njbd:
#Note: njbd dataframe will be place where all data can be acquired from for project in future.
#I will continue analyzing a subset of njbd with fewer columns. 

st_write(njbd, "data_in_progress/njbd.geojson")

## PART 2: SIMPLIFY DF AND CREATE COUNT FOR 2 DIGIT NAICS BY MUNICIPALITY ======

#Bring in municipality data for spatial join:
mun <- st_read("data_in_progress/mun_boundaries.geojson") %>%
  select(SSN) %>%
  st_transform(3424)

nj_bus <- njbd %>%
  select(Company, naics9 = "Primary NAICS Code", sales_volume = "Sales Volume (9) - Location", 
         emp_size = "Employee Size (5) - Location") %>% #grab useful columns
  mutate(naics_2 = str_sub(naics9, start = 1L, end = 2L)) %>%
  select(-naics9) %>%
  
  
  st_set_crs(3424) %>% #Names crs
  st_transform(3424) %>% #Actually sets crs
  st_join(mun) %>% #Adds municipality via spatial join
  
  group_by(SSN) %>%
  summarize(
    
  #Want to group by SSN then get count of each 2 digit NAICS code, as well as the other columns
    # Will need to think about shape of data
    
  
  
  

