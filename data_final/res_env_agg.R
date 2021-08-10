
### Residential environment

setwd("~/Documents/GitHub/NJ-opioidenv/data_in_progress")
residential_environment <- read.csv("residential_environment.csv")

### Read in crosswalk
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")
cw <- rename(cw, GEOID = TRACTID)

###

### merge crosswalk and distance matrix
cw_merge <- merge(residential_environment, cw, by.x = "GEOID", by.y = "GEOID")

### new

sub <- c("SSN", "pop_own_20yrs_plus", "pop_ren_20yrs_plus", "prop_of_ct")


new <- cw_merge[sub]

new$total <- new$pop_own_20yrs_plus + new$pop_ren_20yrs_plus

new$weighted <- new$total * new$prop_of_ct


final <- aggregate(new$weighted, by=list(SSN=new$SSN), FUN=sum)
final <- rename(final, num_households_20yrs = x)


### Percent renter


# merge crosswalk and distance matrix
cw_merge2 <- merge(residential_environment, cw, by.x = "GEOID", by.y = "GEOID")


#subset

sub2 <- c("SSN", "occupied_renter", "occupied_units", "prop_of_ct")

rent <- cw_merge2[sub2]


rent$percent <- rent$occupied_renter / rent$occupied_units

rent$percent_renters <- rent$percent * rent$prop_of_ct


### merge with 20 year occupancy

final <- merge(final, rent, by = "SSN")

final$occupied_renter = NULL

final$occupied_units= NULL

final$percent = NULL

final$prop_of_ct = NULL


### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(final, "res_env.csv", row.names = FALSE) 



### Merge to master

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
re <- read.csv("num_households_20yrs.csv")
master <- read.csv("master_clean.csv")

master_updated <- merge(master, re, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")


write.csv(master, "master_clean.csv", row.names = FALSE) 
