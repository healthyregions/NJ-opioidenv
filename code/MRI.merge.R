

### Load MRI data
setwd("~/Documents/HEROP")
MRI <- read.csv("MRI.csv")

MRI <- rename(MRI, SSN = X)
MRI <- rename(MRI, percent_SNAP = per_snap)
MRI <- rename(MRI, avg_property_tax = avg_prop_tax)



MRI$percent_SNAP <- as.numeric(substr(MRI$percent_SNAP, 1, 4))


MRI$Municipality = NULL


###load master
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("master_clean.csv")

master$avg_prop_tax = NULL
master$percent_SNAP = NULL
master$MRI.Score = NULL

master_updated <- merge(master, MRI, by = "SSN")

### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "master_clean.csv", row.names =  FALSE) 