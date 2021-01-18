#Business Measures
#Gabe Morrison

#Load Packages:
library(tidyverse)
library(tidylog)
library(sf)
library(data.table)
library(vegan)


#PART 1: GETTING A USABLE df/sf object ========
#Prep for getting documents
#Note: here I read the data with 20 rows and then extract column type. I used that in the fread/colClasses call  
  
  #bdhead <- fread("data_raw/2014_Business_Academic_QCQ.txt",
  #                nrows = 20)
  #names_of_cols2 <- sapply(bdhead, class)


#Read Data function:
#Reads text data and only selects potentially relevant columns 
#Also filters only for NJ and adds a geometry column
read_data <- function(location_of_file, data_year = "2014") {
  df <- fread(location_of_file, 
              colClasses=c(
                "character", "NULL",
                "NULL", "character",
                "NULL", "NULL",
                "NULL", "NULL",
                "NULL", "NULL",
                "NULL", "NULL", 
                "NULL", "integer",
                "NULL", "NULL",
                "NULL", "NULL" ,
                "NULL", "NULL" ,
                "NULL", "NULL" ,
                "NULL", "NULL" ,
                "NULL", "integer" ,
                "NULL", "integer", #28
                "integer", "NULL", 
                "NULL", "NULL", 
                "NULL", "NULL",
                "NULL", "NULL",
                "NULL", "NULL",
                "NULL", "NULL",
                "NULL", "NULL",
                "NULL", "NULL",
                "NULL", "NULL",
                "float64", "float64", 
                "NULL", "NULL",
                "NULL", "NULL",
                "NULL"), 
              showProgress = TRUE)
  df <- df[df$State == "NJ", ]
  df <- df %>%
    as.data.frame() %>%
    st_as_sf(coords = c("Longitude", "Latitude"))
}

#Call Function:
njbd2014 <- read_data("data_raw/2014_Business_Academic_QCQ.txt")
njbd2018 <- read_data("data_raw/2018_Business_Academic_QCQ.txt")


#Write 
#st_write(njbd2014, "data_in_progress/njbd2014.geojson")
#st_write(njbd2018, "data_in_progress/njbd2018.geojson")


## PART 2: SIMPLIFY DF AND CREATE COUNT FOR 2 DIGIT NAICS BY MUNICIPALITY ======

#Bring in municipality data for spatial join:
mun <- st_read("data_in_progress/mun_boundaries.geojson") %>%
  select(SSN) %>%
  st_transform(3424)

#Function that cleans data by selecting relevant columns (naics code, sales volume, employee size)
clean_add_mun <- function(df) {
  st_crs(df) <- 3424
  
    df <- df %>%
    select(Company, naics9 = "Primary NAICS Code", sales_volume = "Sales Volume (9) - Location", 
           emp_size = "Employee Size (5) - Location") %>%
    mutate(naics_2 = str_sub(naics9, start = 1L, end = 2L)) %>%
    st_transform(3424) %>%
    st_join(mun) #%>%#Adds municipality via spatial join
    #as.data.frame() %>% #Converts to dataframe
    #select(-geometry)
}

#Function to count the number of businesses in each municipality and to find what percent each
#2 digit NAICS businesses constitute of municipality total
bus_naics_count <- function(df) {
  df %>%
    group_by(SSN, naics_2) %>% #shapes df to unique SSN and naics2
    summarize(n = n()) %>% #counts the number of naics2 in each ssn
    mutate(naics_2 = as.character(naics_2)) %>% 
    mutate(naics_2 = paste0("pct_naics_2_", naics_2)) %>% #Renames naics2 to pct_naics_2_{naicscode} 
    pivot_wider(names_from = naics_2, values_from = n, values_fill = 0) %>% #Reshapes to organize by mun
    mutate(all_bus = rowSums(across(pct_naics_2_21:pct_naics_2_NA))) %>% #Gets new column with sum of all businesses in the mun
    mutate(across(starts_with("pct_naics"), {~.x / all_bus})) #%>% #Converts rows from counts to percent 
    #mutate(across(starts_with("pct_naics"), ~replace(., .==NaN, 0))) %>%
    #mutate(across(starts_with("pct_naics"), ~replace(., .==Inf, 0))) 
}

#Function that computes each municipality's mean and median employee size and sales volume 
bus_size_emp <- function(df) {
  df %>%
    group_by(SSN) %>%
    summarize(mean_emp_size = mean(emp_size, na.rm = TRUE), 
              med_emp_size = median(emp_size, na.rm = TRUE),
              mean_sales_vol = mean(sales_volume, na.rm = TRUE),
              med_sales_vol = median(sales_volume, na.rm = TRUE)
    )
}

#Read Data Previously Written:
#njbd2014 <- st_read("data_in_progress/njbd2014.geojson")
#njbd2018 <- st_read("data_in_progress/njbd2018.geojson")


#Call functions:
njbd2014_clean_mun <- clean_add_mun(njbd2014)
nj_naics2014 <- bus_naics_count(njbd2014_clean_mun)
nj_buscount2014 <-bus_size_emp(njbd2014_clean_mun)

njbd2018_clean_mun <- clean_add_mun(njbd2018, data_year = "2018")
nj_naics2018 <- bus_naics_count(njbd2018_clean_mun)
nj_buscount2018 <-bus_size_emp(njbd2018_clean_mun)



#Join 
nj_bus_mun2014 <- left_join(nj_buscount2014, nj_naics2014)
nj_bus_mun2014 <- left_join(nj_buscount2018, nj_naics2018)





#PART 3 SIMPSON INICES ==================
`

compute_simpson <- function (df) {
  df %>%
    filter(emp_size != 'NA') %>%
    group_by(SSN) %>%
    summarize(simp_index_emp_size = diversity(emp_size, index = "simpson"))
}

njbd_simpson2014 <- compute_simpson(njbd2014)

#Join to data from part2:
nj_bus_mun2014 <- left_join(nj_bus_mun2014, njbd_simpson2014) %>%
  relocate(simp_index_emp_size, .after = "med_sales_vol")



#Write Data:
write.csv(nj_bus_mun2014, "data_in_progress/nj_bus_mun2014.csv")
`