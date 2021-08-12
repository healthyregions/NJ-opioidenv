

#### NRTC merge

###load data

setwd("~/Documents/HEROP")
nrtc <- read.csv("nrtc.csv")

nrtc$median_rent <- as.numeric(gsub(",", "", nrtc$median_rent))
nrtc$median_home_value <- as.numeric(gsub(",", "", nrtc$median_home_value))
nrtc$percent_housing_cost_burdened <- substr(nrtc$percent_housing_cost_burdened,1,nchar(nrtc$percent_housing_cost_burdened)-1)
nrtc$percent_housing_cost_burdened <- as.numeric(nrtc$percent_housing_cost_burdened)


### load cw
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")



#merge
cw_merge <- left_join(cw, nrtc, by = "TRACTID")

cw_merge$Place.Name = NULL
cw_merge$TRACTID = NULL

cw_merge$prop_of_ct = NULL



### agg

final1 <- aggregate(cw_merge$median_rent, by=list(SSN=cw_merge$SSN), FUN=median)
final1 <- rename(final1, median_rent = x)

final2 <- aggregate(cw_merge$median_home_value, by=list(SSN=cw_merge$SSN), FUN=median)
final2 <- rename(final2, median_home_value = x)

final3 <- aggregate(cw_merge$percent_housing_cost_burdened, by=list(SSN=cw_merge$SSN), FUN=median)
final3 <- rename(final3, percent_housing_cost_burdened = x)


###merge

final <- merge(final1, final2, by = "SSN")

final <- merge(final, final3, by = "SSN")


### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(final, "nrtc_housing.csv", row.names = FALSE) 



#___________________________________________________________

###Merge to master

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
nrtc <- read.csv("nrtc_housing.csv")
master <- read.csv("master_clean.csv")

master_updated <- merge(master, nrtc, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "master_clean.csv", row.names = FALSE) 







