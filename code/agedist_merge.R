
# Read in ME data
setwd("~/Documents/GitHub/NJ-opioidenv/data_final/ME deaths shapefile")

ME_shp <- read_sf("ME_deaths.shp")

ME_shp$SSN <- as.numeric(ME_shp$SSN)

## Read in Pop age dist data

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

agedist <- read.csv("pop_agedist.csv")


### Merge

ME_agedist <- merge(ME_shp, agedist, by = "SSN")


### New variables

#over 16
ME_agedist$all_o16 <- ME_agedist$deathCt * 100000/ ME_agedist$over16
ME_agedist$p15_o16 <- ME_agedist$dtC2015 * 100000/ ME_agedist$over16
ME_agedist$p16_o16 <- ME_agedist$dtC2016 * 100000/ ME_agedist$over16
ME_agedist$p17_o16 <- ME_agedist$dtC2017 * 100000/ ME_agedist$over16
ME_agedist$p18_o16 <- ME_agedist$dtC2018 * 100000/ ME_agedist$over16

#under 40

ME_agedist$all_u40 <- ME_agedist$deathCt * 100000 / ME_agedist$under40
ME_agedist$p15u40 <- ME_agedist$dtC2015 * 100000/ ME_agedist$under40
ME_agedist$p16u40 <- ME_agedist$dtC2016 * 100000/ ME_agedist$under40
ME_agedist$p17u40 <- ME_agedist$dtC2017 * 100000/ ME_agedist$under40
ME_agedist$p18u40 <- ME_agedist$dtC2018 * 100000/ ME_agedist$under40


## Over 40

ME_agedist$all_o40 <- ME_agedist$deathCt * 100000/ ME_agedist$over40
ME_agedist$p15_o40 <- ME_agedist$dtC2015 * 100000/ ME_agedist$over40
ME_agedist$p16_o40 <- ME_agedist$dtC2016 * 100000/ ME_agedist$over40
ME_agedist$p17_o40 <- ME_agedist$dtC2017 * 100000/ ME_agedist$over40
ME_agedist$p18_o40 <- ME_agedist$dtC2018 * 100000/ ME_agedist$over40



#Save shp
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

st_write(ME_agedist, "ME_agedist.shp", append = TRUE)


## Save CSV
ME_agedist$geometry = NULL
ME_agedist$




