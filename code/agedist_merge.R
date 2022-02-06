
# Read in ME data
setwd("~/Documents/GitHub/NJ-opioidenv/data_final/ME deaths shapefile")

ME_shp <- read_sf("ME_deaths.shp")

ME_shp$SSN <- as.numeric(ME_shp$SSN)

## Read in Pop age dist data

setwd("~/Documents/GitHub/NJ-opioidenv/data_in_progress")

agedist <- read.csv("NJ_1564yo.csv")


### Merge

ME_agedist <- merge(ME_shp, agedist, by = "SSN")


### New variables

# 15 - 64 yo
ME_agedist$allyears <- ME_agedist$deathCt * 100000/ ME_agedist$total1564
ME_agedist$p2015 <- ME_agedist$dtC2015 * 100000/ ME_agedist$total1564
ME_agedist$p2016 <- ME_agedist$dtC2016 * 100000/ ME_agedist$total1564
ME_agedist$p2017 <- ME_agedist$dtC2017 * 100000/ ME_agedist$total1564
ME_agedist$p2018 <- ME_agedist$dtC2018 * 100000/ ME_agedist$total1564

ME_agedist$geometry = NULL
ME_agedist$deathCt = NULL
ME_agedist$dtC2015 = NULL
ME_agedist$dtC2016 = NULL
ME_agedist$dtC2017 = NULL
ME_agedist$dtC2018 = NULL
ME_agedist$total1564 = NULL


#save CSV
setwd("~/Documents/GitHub/NJ-opioidenv/data_in_progress")

write.csv(ME_agedist, "DthRates", row.names = FALSE)

### Merge to masters
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("working_master(abridged).csv")

ME_agedist <- ME_agedist[c("SSN", "allyears")]

master_updated <- merge(master, ME_agedist, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "working_master(abridged).csv", row.names = FALSE) 