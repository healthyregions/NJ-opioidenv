
library(dplyr)

# Read in ME data
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

ME_shp <- read.csv("ME_deaths.csv")

ME_shp$SSN <- as.numeric(ME_shp$SSN)




## Read in Pop age dist data

setwd("~/Documents/GitHub/NJ-opioidenv/data_in_progress")

agedist <- read.csv("NJ_1564yo.csv")


### Merge

ME_agedist <- merge(ME_shp, agedist, by = "SSN")


### New variables

# 15 - 64 yo
ME_agedist$rAll <- ME_agedist$deathCt * 100000/ ME_agedist$total1564
ME_agedist$r2015 <- ME_agedist$deathCt2015 * 100000/ ME_agedist$total1564
ME_agedist$r2016 <- ME_agedist$deathCt2016 * 100000/ ME_agedist$total1564
ME_agedist$r2017 <- ME_agedist$deathCt2017 * 100000/ ME_agedist$total1564
ME_agedist$r2018 <- ME_agedist$deathCt2018 * 100000/ ME_agedist$total1564


ME_agedist <- rename(ME_agedist, dtC2015 = deathCt2015)
ME_agedist <- rename(ME_agedist, dtC2016 = deathCt2016)
ME_agedist <- rename(ME_agedist, dtC2017 = deathCt2017)
ME_agedist <- rename(ME_agedist, dtC2018 = deathCt2018)


ME_agedist$geometry = NULL
ME_agedist$deathCt = NULL
ME_agedist$total1564 = NULL


#save CSV
setwd("~/Documents/GitHub/NJ-opioidenv/data_in_progress")

write.csv(ME_agedist, "DthRates.csv", row.names = FALSE)



## merge to shape
library(sf)
# New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")
nj_municipal$SSN <- as.numeric(nj_municipal$SSN)

sub <- nj_municipal[c("MUN", "COUNTY", "MUN_LABEL", "SSN", "geometry")]

deaths_sf <- merge(sub, ME_agedist, by = "SSN")


#### percent changes

deaths_sf$pctCh1516 = (((deaths_sf$r2016 - deaths_sf$r2015)/deaths_sf$r2015) * 100)
deaths_sf$pctCh1617 = (((deaths_sf$r2017 - deaths_sf$r2016)/deaths_sf$r2016) * 100)
deaths_sf$pctCh1718 = (((deaths_sf$r2018 - deaths_sf$r2017)/deaths_sf$r2017) * 100)

deaths_sf$pctCh1518 = (((deaths_sf$r2018 - deaths_sf$r2015)/deaths_sf$r2015) * 100)

### avg

deaths_sf$avg1516 = (deaths_sf$deathCt2015 + deaths_sf$deathCt2016 +
                       deaths_sf$deathCt2017 + deaths_sf$deathCt2018) / 4



#remove Nan

deaths_sf$pctCh1516 <- ifelse(is.nan(deaths_sf$pctCh1516), 0, deaths_sf$pctCh1516)
deaths_sf$pctCh1617 <- ifelse(is.nan(deaths_sf$pctCh1617), 0, deaths_sf$pctCh1617)
deaths_sf$pctCh1718 <- ifelse(is.nan(deaths_sf$pctCh1516), 0, deaths_sf$pctCh1516)
deaths_sf$pctCh1516 <- ifelse(is.nan(deaths_sf$pctCh1516), 0, deaths_sf$pctCh1516)



## remove inf

deaths_sf$pctCh1516 <- ifelse(deaths_sf$pctCh1516 == Inf, NA, deaths_sf$pctCh1516)
deaths_sf$pctCh1617 <- ifelse(deaths_sf$pctCh1617 == Inf, NA, deaths_sf$pctCh1617)
deaths_sf$pctCh1718 <- ifelse(deaths_sf$pctCh1718 == Inf, NA, deaths_sf$pctCh1718)

deaths_sf$pctCh1518 <- ifelse(deaths_sf$pctCh1518 == Inf, NA, deaths_sf$pctCh1518)


#### ######## increase or decrease year to year

deaths_sf$change16 <- ifelse(deaths_sf$r2015 < deaths_sf$r2016, 1, -1)
deaths_sf$change17 <- ifelse(deaths_sf$r2015 < deaths_sf$r2016, 1, -1)
deaths_sf$change18 <- ifelse(deaths_sf$r2015 < deaths_sf$r2016, 1, -1)
deaths_sf$changeall <- ifelse(deaths_sf$r2015 < deaths_sf$r2018, 1, -1)



setwd("~/Documents/HEROP/NJ Opioids")
st_write(deaths_sf,"death_agedist", driver = "ESRI Shapefile", append = TRUE)






### Merge to masters
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("working_master(abridged).csv")

ME_agedist <- ME_agedist[c("SSN", "allyears")]

master_updated <- merge(master, ME_agedist, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "working_master(abridged).csv", row.names = FALSE) 