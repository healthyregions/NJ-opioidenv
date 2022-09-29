

## pull 16 - 64 year olds

library(sf)
library(tidycensus)
library(tidyverse)
library(tigris)

sVarNames <- load_variables(2018, "acs5/subject", cache = TRUE)
pVarNames <- load_variables(2018, "acs5/profile", cache = TRUE)
otherVarNames <- load_variables(2018, "acs5", cache = TRUE)


NJ_agedist <- get_acs(geography = 'tract',variables = c(totpop18 = "B06001_001",
                                                        a04 = "S0101_C01_002",
                                                        a59 = "S0101_C01_003",
                                                        a1014 = "S0101_C01_004",
                                                        a1520 = "S0101_C01_005",
                                                          a2024 = "S0101_C01_006",
                                                          a2529 = "S0101_C01_007",
                                                          a3034 = "S0101_C01_008",
                                                          a3539 = "S0101_C01_009",
                                                          a4044 = "S0101_C01_010",
                                                          a4549 = "S0101_C01_011",
                                                        a5054 = "S0101_C01_012",
                                                        a5559 = "S0101_C01_013",
                                                        a6064 = "S0101_C01_014",
                                                        a6569 = "S0101_C01_015",
                                                        a7074 = "S0101_C01_016",
                                                        a7580 = "S0101_C01_017",
                                                        a8084 = "S0101_C01_018",
                                                        a85 = "S0101_C01_019"),
                      year = 2018, state = 'NJ', geometry = FALSE) %>% 
  select(GEOID, NAME, variable, estimate) %>% 
  spread(variable, estimate) %>% 
  mutate(pop18_1564 = (a1520 + a2024 + a2529 + a3034 + a3539 + a4044 + a4549 + a5054 + a5559 + a6064),
         pop18_1564P = pop18_1564/totpop18 * 100) %>%
  select(GEOID, totpop18, pop18_1564, pop18_1564P,
         a04,a59,a1014,a1520,a2024,a2529,a3034,a3539,a4044,
         a4549,a5054,a5559,a6064,a6569,a7074,a7580,a8084,a85)

head(NJ_agedist)

### Read in crosswalk
setwd("~/Code/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")
cw <- rename(cw, GEOID = TRACTID)

### merge crosswalk and distance matrix
cw_merge <- merge(NJ_agedist, cw, by = "GEOID")
head(cw_merge)

### Weighted column
cw_merge <- cw_merge %>%
  mutate(totpop18 = totpop18 * prop_of_ct,
         pop18_1564 = pop18_1564 * prop_of_ct,
         pop18_1564P = pop18_1564P * prop_of_ct,
         a04 = a04 * prop_of_ct,
         a59 = a59 * prop_of_ct,
         a1014 = a1014 * prop_of_ct,
         a1520 = a1520 * prop_of_ct,
         a2024 = a2024 * prop_of_ct,
         a2529 = a2529 * prop_of_ct,
         a3034 = a3034 * prop_of_ct,
         a3539 = a3539 * prop_of_ct,
         a4044 = a4044 * prop_of_ct,
         a4549 = a4549 * prop_of_ct,
         a5054 = a5054 * prop_of_ct,
         a5559 = a5559 * prop_of_ct,
         a6064 = a6064 * prop_of_ct,
         a6569 = a6569 * prop_of_ct,
         a7074 = a7074 * prop_of_ct,
         a7580 = a7580 * prop_of_ct,
         a8084 = a8084 * prop_of_ct,
         a85 = a85 * prop_of_ct)
head(cw_merge)

### Aggregate

#final <- aggregate(cw_merge$pop18_1564, 
#                   by=list(SSN=cw_merge$SSN), FUN=sum)

final <- cw_merge %>%
  group_by(SSN) %>%
  summarize(totpop18 = sum(totpop18, na.rm = TRUE),
            pop18_1564 = sum(pop18_1564, na.rm = TRUE),
            a04 = sum(a04, na.rm = TRUE),
            a59 = sum(a59, na.rm = TRUE),
            a1014 = sum(a1014, na.rm = TRUE),
            a1520 = sum(a1520, na.rm = TRUE),
            a2024 = sum(a2024, na.rm = TRUE),
            a2529 = sum(a2529, na.rm = TRUE),
            a3034 = sum(a3034, na.rm = TRUE),
            a3539 = sum(a3539, na.rm = TRUE),
            a4044 = sum(a4044, na.rm = TRUE),
            a4549 = sum(a4549, na.rm = TRUE),
            a5054 = sum(a5054, na.rm = TRUE),
            a5559 = sum(a5559, na.rm = TRUE),
            a6064 = sum(a6064, na.rm = TRUE),
            a6569 = sum(a6569, na.rm = TRUE),
            a7074 = sum(a7074, na.rm = TRUE),
            a7580 = sum(a7580, na.rm = TRUE),
            a8084 = sum(a8084, na.rm = TRUE),
            a85 = sum(a85, na.rm = TRUE)
                             )


head(final)

final$pop18_1564P = (final$pop18_1564 / final$totpop18) * 100
head(final)


#save
setwd("~/Code/NJ-opioidenv/data_in_progress")

write.csv(final, "NJ_1564yoAJ.csv", row.names = FALSE)


test<- read.csv("NJ_1564yo.csv")
head(test)

setwd("~/Code/NJ-opioidenv/data_final")

njmaster <- read_sf("NJMaster_finalindex3.geojson")
glimpse(njmaster)

njmaster.final <- merge(njmaster, test, by = "SSN")

glimpse(njmaster.final)
njmaster.final[c("SSN", "pop2017", "totpop18", "pop18_1564"),]
glimpse(njmaster.final)

njmaster.final$opDtRt15 <- (njmaster.final$opDt15/njmaster.final$pop18_1564) * 10000
njmaster.final$opDtRt16 <- (njmaster.final$opDt16/njmaster.final$pop18_1564) * 10000
njmaster.final$opDtRt17 <- (njmaster.final$opDt17/njmaster.final$pop18_1564) * 10000
njmaster.final$opDtRt18 <- (njmaster.final$opDt18/njmaster.final$pop18_1564) * 10000
njmaster.final$opDtRt1518ave <- (njmaster.final$opDtRt15 +
                                   njmaster.final$opDtRt16 +
                                   njmaster.final$opDtRt17 +
                                   njmaster.final$opDtRt18) / 4
glimpse(njmaster.final)


library(tmap)
tm_shape(njmaster.final) + tm_fill("opDtRt1518ave", n = 5, style = "quantile")


write.csv(njmaster.final, "NJMaster_finalindex4.csv")
st_write(njmaster.final, "NJMaster_finalindex4.geojson")

ggplot(njmaster.final, aes(x=opDtRt1518ave)) + 
  geom_histogram(binwidth = 1, color="black") + 
  facet_wrap( ~ landUseClass)

tm_shape(njmaster.final) + tm_fill("opDtRt1518ave", style = "quantile")

      