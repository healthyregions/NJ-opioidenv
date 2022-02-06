

## pull 16 - 64 year olds

library(sf)
library(tidycensus)
library(tidyverse)
library(tigris)

sVarNames <- load_variables(2018, "acs5/subject", cache = TRUE)
pVarNames <- load_variables(2018, "acs5/profile", cache = TRUE)
otherVarNames <- load_variables(2018, "acs5", cache = TRUE)


NJ_agedist <- get_acs(geography = 'tract',variables = c(a1520 = "S0101_C01_005",
                                                          a2024 = "S0101_C01_006",
                                                          a2529 = "S0101_C01_007",
                                                          a3034 = "S0101_C01_008",
                                                          a3539 = "S0101_C01_009",
                                                          a4044 = "S0101_C01_010",
                                                          a4549 = "S0101_C01_011",
                                                        a5054 = "S0101_C01_012",
                                                        a5559 = "S0101_C01_013",
                                                        a6064 = "S0101_C01_014"),
                        year = 2018, state = 'NJ', geometry = FALSE) %>% 
  select(GEOID, NAME, variable, estimate) %>% 
  spread(variable, estimate) %>% 
  mutate(total = (a1520 + a2024 + a2529 + a3034 + a3539 + a4044 + a4549 + a5054 + a5559 + a6064)) %>%
  select(GEOID, total)


### Read in crosswalk
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")
cw <- rename(cw, GEOID = TRACTID)

### merge crosswalk and distance matrix
cw_merge <- merge(NJ_agedist, cw, by = "GEOID")

### Weighted column
cw_merge <- cw_merge %>%
  mutate(mun_total = total * prop_of_ct)

### Aggregate

final <- aggregate(cw_merge$mun_total, by=list(SSN=cw_merge$SSN), FUN=sum)
final <- rename(final, total1564 = x)

#save
setwd("~/Documents/GitHub/NJ-opioidenv/data_in_progress")

write.csv(final, "NJ_1564yo.csv")
