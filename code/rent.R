library(tidyverse)
library(tidycensus)

# check for available variables in the census data 
ACS18var <- load_variables(2018, "acs5", cache = TRUE)
view(ACS18var)

rent_acs <- get_acs(
  state = "NJ",
  geography = "tract",
  variables = c(rent_gross = "B25063_001"),
  year = 2018,
  geometry = FALSE
)

# cleaning
rent <- rent_acs %>% 
  select(GEOID, NAME, variable, estimate) %>% 
  spread(variable, estimate)
head(rent)

# Save as csv file
write_csv(rent, "rent.csv")
