library(tidyverse)
library(tidycensus)

# check for available variables in the census data 
ACS18var <- load_variables(2018, "acs5", cache = TRUE)
view(ACS18var)

econ_acs <- get_acs(
  state = "NJ",
  geography = "tract",
  variables = c(
    income_household = "B19001_001",
    employment = "B23025_001",
    pop_total = "B01003_001"
  ),
  year = 2018,
  geometry = FALSE
)

# cleaning
econ <- econ_acs %>% 
  select(GEOID, NAME, variable, estimate) %>% 
  spread(variable, estimate) %>% 
mutate(
  income_per_cap = income_household/pop_total, 
  employment_per_cap = employment/pop_total,
  mobile_home_rate = mobile_home/total_units,
  multiunit_struct = multiunits_two + multiunits_three_or_four + multiunits_five_to_nine + multiunits_10_to_19 + multiunits_20_to_49 + multiunits_50plus,
  pop_own_20yrs_plus = pop_own_90_99 + pop_own_bfr89,
  pop_ren_20yrs_plus = pop_ren_90_99 + pop_ren_bfr89,
  pop_20yrs_plus = pop_own_20yrs_plus + pop_ren_20yrs_plus
) %>%
  select(GEOID,occupancy_rate, vacancy_rate, multiunit_struct, mobile_home_rate, pop_20yrs_plus, no_vehicle, public_transit, everything())
head(econ)

# Save as csv file
write_csv(econ, "community_econ.csv")
