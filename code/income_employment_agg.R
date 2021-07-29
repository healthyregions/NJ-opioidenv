

### Load community data

community_econ <- read.csv("~/Documents/GitHub/NJ-opioidenv/data_final/community_econ.csv")

## at tract level so will need to be weighed and merged


### Merge with tracts?

##read tracts
setwd("~/Documents/HEROP/tl_2018_34_tract")
tracts <- read_sf("tl_2018_34_tract.shp")

#merge
econ_tracts <- merge(community_econ, tracts, by="GEOID")

### Load crosswalk

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")
cw <- rename(cw, GEOID = TRACTID)


### Merge 'merge' with cw

merge_cw <- merge(cw, econ_tracts, by = "GEOID")


### New by subset
new <- c("SSN", "income_per_cap", "employ_per_cap", "prop_of_ct")

sub <- merge_cw[new]



## Create weighted column for income and employment

sub <- sub %>%
  mutate(weighted_d_inc = income_per_cap * prop_of_ct)

sub <- sub %>%
  mutate(weighted_d_emp = employ_per_cap * prop_of_ct)

### agg 


ipc <- aggregate(sub$weighted_d_inc, by=list(SSN=sub$SSN), FUN=mean, na.rm = TRUE)
ipc <- rename(ipc, income_per_capita = x)


epc <- aggregate(sub$weighted_d_emp, by=list(SSN=sub$SSN), FUN=mean, na.rm = TRUE)
epc <- rename(epc, employment_per_capita = x)

### merge together

final <- merge(ipc, epc, by = "SSN")

### save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(final, "community_econ_agg.csv", row.names = FALSE) 

### Merge to master

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
comm_econ <- read.csv("community_econ_agg.csv")
master <- read.csv("master_clean.csv")


master_updated <- merge(master, comm_econ, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "master_clean.csv", row.names = FALSE) 


