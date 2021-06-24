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
    employ_total = "B23025_001",
    employed = "B23025_004",
    unemployed = "B23025_005"
  ),
  year = 2018,
  geometry = FALSE
)

# cleaning
econ <- econ_acs %>% 
  select(GEOID, NAME, variable, estimate) %>% 
  spread(variable, estimate) %>% 
  select(-NAME) %>%
  mutate(employ_per_cap = employed/employ_total)
head(econ)

# Save as csv file
write_csv(econ, "community_econ.csv")

community_econ <- read.csv("community_econ.csv")
