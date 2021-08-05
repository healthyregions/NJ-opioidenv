

### Load MRI data
setwd("~/Documents/HEROP")
MRI <- read.csv("MRI.csv")

MRI <- rename(MRI, SSN = X)
MRI <- rename(MRI, percent_SNAP = per_snap)
MRI <- rename(MRi, avg_property_tax = avg_per_snap)

MRI$Municipality = NULL


###load master
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("master_clean.csv")


master_updated <- merge(master, MRI, by = "SSN")

### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "master_clean.csv", row.names =  FALSE) 