

#### Aggregate crowded housing



## SUT Locations
setwd("~/Documents/HEROP")
svi <- read.csv("NewJersey.csv")

# clean

sub <- c("FIPS", "EP_CROWD")

new <- svi[sub]


### Read in crosswalk
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")
cw <- rename(cw, FIPS = TRACTID)

### merge crosswalk and distance matrix
cw_merge <- merge(new, cw, by = "FIPS")

### Weighted column
cw_merge <- cw_merge %>%
  mutate(percent_crowded = EP_CROWD * prop_of_ct)

### Aggregate

final <- aggregate(cw_merge$percent_crowded, by=list(SSN=cw_merge$SSN), FUN=mean)
final <- rename(final, percent_crowded = x)



### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(final, "crowded_housing.csv", row.names = FALSE)


#___________________________________________________________

###Merge to master

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
crowded <- read.csv("crowded_housing.csv")
master <- read.csv("master_clean.csv")

master_updated <- merge(master, crowded, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "master_clean.csv", row.names = FALSE)


master_updated$bike_path_ft_p_mile[is.na(master_updated$bike_path_ft_p_mile)] <- 0

master_updated$bikes_ft_p_mile[is.na(master_updated$bikes_ft_p_mile)] <- 0 