
## MOUD has: tract level (GEOID), minimum distance
## tracts has: tract (TRACTID)
## cw has: tracts (GEOID), SSN


### Read in MOUD data
setwd("~/Documents/GitHub/opioid-policy-scan/data_final")
MOUD_min_dist_t <- read_csv("~/Documents/GitHub/opioid-policy-scan/data_final/Access01_T.csv")
# clean
MOUD_min_dist_t <- rename(MOUD_min_dist_t, TRACTID = GEOID)


### Read in tract data
setwd("~/Documents/HEROP/nhgis0003_csv")
tracts <- read.csv ("nhgis0003_ds244_20195_2019_tract.csv")

## clean
#library(splitstackshape)

tracts <- cSplit(tracts, "GEOID", "US")

tracts = subset(tracts, select = -c(GEOID_1))

tracts <- rename(tracts, TRACTID = GEOID_2)


### Merge tract with MOUD
# Left Join

merge <- left_join(MOUD_min_dist_t, tracts, by = "TRACTID")



### Read in crosswalk

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")


### Merge 'merge' with cw
# Left Join

merge_cw <- left_join(cw, merge, by = "TRACTID")


### New by subset
new <- c("Place.Name", "SSN", "TRACTID", "minDisMOUD")

subset <- merge_cw[new]

## agg avg min dist
mindist_mun <- aggregate(subset$minDisMOUD, by=list(SSN=subset$SSN), FUN=mean)
mindist_mun <- rename(mindist_mun, avg_min_dist = x)


## agg % of tracts closer than 10 miles
# create a variable for less than 10 miles (binary)
subset$lessthan10 <- ifelse(subset$minDisMOUD < 10, 1, 0)

# create a dummy variable that sums # of tracts
subset$all <- 1

# create two aggregated datasets
sub_10 <- aggregate(subset$lessthan10, by=list(SSN=subset$SSN), FUN=sum)
sub_10 <- rename(sub_10, num_less = x)

all <- aggregate(subset$all, by=list(SSN=subset$SSN), FUN=sum)
all <- rename(all, all = x)

#left merge

dummy_merge <- left_join(sub_10, all, by = "SSN")

#new column for num less / total

dummy_merge$prop_under_10mi <- dummy_merge$num_less / dummy_merge$all


# left merge with avg min dist

final <- left_join(mindist_mun, dummy_merge, by = "SSN")

final = subset(final, select = -c(num_less, all))

#save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(final, "MOUD_distance_municipality.csv") 



