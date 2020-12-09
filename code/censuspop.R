#Getting up to data Population data for Tract:

library(sf)
library(tidycensus)
library(tidyverse)

nj_tract_pop_16 <-  get_acs(geography = 'tract',
                            variables = c(totpop16 = "B01001_001"),
                            year = 2018, 
                            state = "NJ",
                            geometry = FALSE) %>%
  select(GEOID, estimate) %>%
  rename("pop2016" = estimate)

st_write(nj_tract_pop_16, "data_in_progress/nj_tract_pop_2016.csv")
