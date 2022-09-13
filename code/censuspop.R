#Getting up to data Population data for Tract and block:

library(sf)
library(tidycensus)
library(tidyverse)

otherVarNames <- load_variables(2018, "acs5", cache = TRUE)

# Updates to include age groups (MK)
nj_tract_pop_18 <-  get_acs(geography = 'tract',
                            variables = c(totpop18 = "B06001_001",
                                          pop18_05 = "B06001_002",
                                          pop18_517 = "B06001_003",
                                          pop18_1824 = "B06001_004",
                                          pop18_2534 = "B06001_005",
                                          pop18_3544 = "B06001_006",
                                          pop18_4554 = "B06001_007",
                                          pop18_5559 = "B06001_008",
                                          pop18_6061 = "B06001_009",
                                          pop18_6264 = "B06001_010"
                                          ),
                            year = 2018, 
                            state = "NJ",
                            geometry = FALSE) %>%
          select(GEOID, NAME, variable, estimate) %>% 
          spread(variable, estimate) %>% 
          mutate(pop18_017 = pop18_05+pop18_517,
                 pop18_1864 = pop18_1824+pop18_2534+pop18_3544 +
                   pop18_4554+pop18_5559+pop18_6061+pop18_6264,
                 pop18_017P = (pop18_017 / totpop18) * 100,
                 pop18_1864P = (pop18_1864 / totpop18) * 100) %>%
          select(GEOID,totpop18,pop18_017, pop18_1864, pop18_017P, pop18_1864P)


glimpse(nj_tract_pop_18)

st_write(nj_tract_pop_18, "data_in_progress/nj_tract_pop_2018.csv")









### Older materials

nj_b_pop_16 <- get_acs(geography = 'block group',
                       variables = c(totpop16 = "B01001_001"),
                       year = 2018, 
                       state = "NJ",
                       geometry = TRUE) %>%
  select(GEOID, estimate) %>%
  rename("pop2016" = estimate)

st_write(nj_b_pop_16, "data_in_progress/nj_bg_pop_2016.geojson")
