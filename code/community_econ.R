library(tidyverse)
library(tidycensus)

# check for available variables in the census data 
ACS18var <- load_variables(2018, "acs5", cache = TRUE)
view(ACS18var)

econ_acs <- get_acs(
  state = "NJ",
  geography = "tract",
  variables = c(
    income_per_cap = "B19301_001",
    employ_per_cap = "B23025_001",
  ),
  year = 2018,
  geometry = FALSE
)

# cleaning
econ <- econ_acs %>% 
  select(GEOID, NAME, variable, estimate) %>% 
  spread(variable, estimate) %>% 
  select(-NAME)
head(econ)

# Save as csv file
write_csv(econ, "community_econ.csv")
