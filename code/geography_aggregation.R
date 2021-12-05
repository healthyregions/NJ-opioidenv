### residential foreclosures

#read geography data

setwd("~/Documents/HEROP")
geog_data <- read.csv("New Jersey urban rural.xlsx - New Jersey.csv")

## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")
nj_municipal$SSN <- as.numeric(nj_municipal$SSN)


sub <- c("SSN", "geometry")

new <- nj_municipal[sub]

new$SSN <- as.numeric(new$SSN)


##clean geog data
keep <- c("type", "SD", "TRACTID")
geog <- geog_data[keep]

#type
geog$num_type <- geog$type

geog$num_type[which(geog$num_type == "Urban")] = 1
geog$num_type[which(geog$num_type == "Suburb")] = 2
geog$num_type[which(geog$num_type == "Exurban")] = 3
geog$num_type[which(geog$num_type == "Town")] = 4
geog$num_type[which(geog$num_type == "Rural")] = 5
geog$num_type[which(geog$num_type == "water")] = 6

geog$num_type <- as.numeric(as.character(geog$num_type))

#sd
geog$num_SD <- geog$SD
geog$num_SD[which(geog$num_SD == "High Density Urban")] = 1
geog$num_SD[which(geog$num_SD == "Medium Density Urban")] = 2
geog$num_SD[which(geog$num_SD == "Suburban")] = 3
geog$num_SD[which(geog$num_SD == "Exurban")] = 4
geog$num_SD[which(geog$num_SD == "Rural")] = 5
geog$num_SD[which(geog$num_SD == "water")] = 6

geog$num_SD <- as.numeric(as.character(geog$num_SD))



## read cw
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")

### merge
merge <- left_join(cw, geog, by = "TRACTID")


####################################### Method 1 - average


## agg

mun_type <- aggregate(merge$num_type, by=list(SSN=merge$SSN), FUN=mean)
mun_type <- rename(mun_type, type = x)
mun_type$type <- round(mun_type$type ,0)

# names
mun_type$name <- mun_type$type

mun_type$name[which(mun_type$name == 1)] = "Urban"
mun_type$name[which(mun_type$name == 2)] = "Suburb"
mun_type$name[which(mun_type$name == 3)] = "Exurban"
mun_type$name[which(mun_type$name == 4)] = "Town"
mun_type$name[which(mun_type$name == 5)] = "Rural"


#merge

class_shp <- merge(new, mun_type, by = "SSN")

setwd("~/Documents/HEROP")
st_write(class_shp,"2_type_avg.shp", driver = "ESRI Shapefile", append = TRUE)


############################################### Type 2 --- Mode

## agg

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}


mun_type2 <- aggregate(merge$num_type, by=list(SSN=merge$SSN), FUN=Mode)
mun_type2 <- rename(mun_type2, type = x)


## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")


sub <- c("SSN", "geometry")

new2 <- nj_municipal[sub]

new2$SSN <- as.numeric(new2$SSN)

# names
mun_type2$name <- mun_type2$type

mun_type2$name[which(mun_type2$name == 1)] = "Urban"
mun_type2$name[which(mun_type2$name == 2)] = "Suburb"
mun_type2$name[which(mun_type2$name == 3)] = "Exurban"
mun_type2$name[which(mun_type2$name == 4)] = "Town"
mun_type2$name[which(mun_type2$name == 5)] = "Rural"



#merge

class_shp2 <- merge(new2, mun_type2, by = "SSN")

setwd("~/Documents/HEROP")
st_write(class_shp2,"2_type_mode.shp", driver = "ESRI Shapefile", append = TRUE)



############################ type 3 - land distribution


areas <- nj_municipal[c("SSN", "SQ_MILES")]
areas$geometry = NULL
areas$SSN <- as.numeric(areas$SSN)


method3 <- merge(merge, areas, by = "SSN")

method3$weight = method3$prop_of_ct * method3$SQ_MILES

library(data.table)

types3 <- setDT(method3)[, .SD[which.max(SQ_MILES)], by=SSN]

types3$Place.Name <- NULL
types3$TRACTID <- NULL
types3$prop_of_ct <- NULL
types3$type <- NULL
types3$SD <- NULL
types3$num_SD <- NULL
types3$SQ_MILES <- NULL
types3$weight <- NULL


geo <- new[c("SSN", "geometry")]

class_shp3 <- merge(geo, types3, by = "SSN")

# names
mun_type$name <- mun_type$type

mun_type$name[which(mun_type$name == 1)] = "Urban"
mun_type$name[which(mun_type$name == 2)] = "Suburb"
mun_type$name[which(mun_type$name == 3)] = "Exurban"
mun_type$name[which(mun_type$name == 4)] = "Town"
mun_type$name[which(mun_type$name == 5)] = "Rural"





#save

setwd("~/Documents/HEROP")
st_write(class_shp3,"2_type_max.shp", driver = "ESRI Shapefile", append = TRUE)

############################ type 4 - percentage of each type (# / total tracts)


## make tally of total tracts in municipality
## total sum of each type of geog by municipality
## agg on those

## dummy total
merge$tracts <- 1

mun_tracts <- aggregate(merge$tracts, by=list(SSN=merge$SSN), FUN=sum)
mun_tracts <- rename(mun_tracts, num_tracts = x)

# gen type 1
merge$type_1 <- ifelse(merge$num_type == '1', 1, 0)

mun_type1 <- aggregate(merge$type_1, by=list(SSN=merge$SSN), FUN=sum)
mun_type1 <- rename(mun_type1, urban = x)
mun_type1$rate_urb <- mun_type1$urban / mun_tracts$num_tracts
mun_type1$urban = NULL

# gen type 2
merge$type_2 <- ifelse(merge$num_type == '2', 1, 0)

mun_type2 <- aggregate(merge$type_2, by=list(SSN=merge$SSN), FUN=sum)
mun_type2 <- rename(mun_type2, suburban = x)
mun_type2$rate_sub <- mun_type2$suburban / mun_tracts$num_tracts
mun_type2$suburban = NULL


# gen type 3
merge$type_3 <- ifelse(merge$num_type == '3', 1, 0)

mun_type3 <- aggregate(merge$type_3, by=list(SSN=merge$SSN), FUN=sum)
mun_type3 <- rename(mun_type3, exurban = x)
mun_type3$rate_ex <- mun_type3$exurban / mun_tracts$num_tracts
mun_type3$exurban = NULL


# gen type 4
merge$type_4 <- ifelse(merge$num_type == '4', 1, 0)

mun_type4 <- aggregate(merge$type_4, by=list(SSN=merge$SSN), FUN=sum)
mun_type4 <- rename(mun_type4, town = x)
mun_type4$rate_town <- mun_type4$town / mun_tracts$num_tracts
mun_type4$town = NULL



# gen type 5
merge$type_5 <- ifelse(merge$num_type == '5', 1, 0)

mun_type5 <- aggregate(merge$type_5, by=list(SSN=merge$SSN), FUN=sum)
mun_type5 <- rename(mun_type5, rural = x)
mun_type5$rate_rur <- mun_type5$rural / mun_tracts$num_tracts
mun_type5$rural = NULL



##### merge

percent_mun_type <- merge(mun_type1, mun_type2, by = "SSN")
percent_mun_type <- merge(percent_mun_type, mun_type3, by = "SSN")
percent_mun_type <- merge(percent_mun_type, mun_type4, by = "SSN")
percent_mun_type <- merge(percent_mun_type, mun_type5, by = "SSN")

geo <- nj_municipal[c("SSN", "geometry")]

percent_mun_type <- merge(percent_mun_type, geo, by = "SSN")

sub <- c("rate_urb", "rate_sub", "rate_ex", "rate_town", "rate_rur")

mun_sub <- percent_mun_type[sub]

percent_mun_type$max <- colnames(mun_sub)[max.col(mun_sub, ties.method = "first")]

# names

percent_mun_type$max[which(percent_mun_type$max == "rate_urb")] = "Urban"
percent_mun_type$max[which(percent_mun_type$max == "rate_sub")] = "Suburb"
percent_mun_type$max[which(percent_mun_type$max == "rate_ex")] = "Exurban"
percent_mun_type$max[which(percent_mun_type$max == "rate_town")] = "Town"
percent_mun_type$max[which(percent_mun_type$max == "rate_rur")] = "Rural"




#percent_mun_type$majority <- ifelse(percent_mun_type$rate_urb > percent_mun_type$rate_sub & 
#                                      percent_mun_type$rate_urb > percent_mun_type$rate_rur, 1, 
#                                    ifelse(percent_mun_type$rate_sub > percent_mun_type$rate_rur, 2, 3))




### for somer reason this is not perfect

#ifelse(percent_mun_type$rate_urb > percent_mun_type$rate_sub, 1, ifelse(percent_mun_type$rate_sub > percent_mun_type$rate_rur, 2, 3))


#save

setwd("~/Documents/HEROP")
st_write(percent_mun_type,"2_type_ratio.shp", driver = "ESRI Shapefile", append = TRUE)



############################ type 5 - area percentage of each type (area of type / area)

## New Jersey Tracts
setwd("~/Documents/HEROP/tl_2018_34_tract")
nj_tract <- read_sf("tl_2018_34_tract.shp")

tract_areas <- nj_tract %>% 
  mutate(tract_area = st_area(nj_tract$geometry))

tract_areas$tract_area <- drop_units(tract_areas$tract_area)
tract_areas <- rename(tract_areas, TRACTID = GEOID)

tract_areas_new <- tract_areas[c("TRACTID", "tract_area")]
tract_areas_new$geometry = NULL

merge <- merge(merge, tract_areas_new, by = "TRACTID")


## make tally of total tracts in municipality
## total sum of each type of geog by municipality
## agg on those





## area total
merge$weighted_tracts <- merge$prop_of_ct * merge$tract_area

mun_tracts <- aggregate(merge$weighted_tracts, by=list(SSN=merge$SSN), FUN=sum)
mun_tracts <- rename(mun_tracts, area_total = x)

# gen type 1

urban <- subset(merge, num_type == "1")


#urban$type_1 <- ifelse(merge$type == '1', merge$tract_area, 0)

mun_type1 <- aggregate(urban$weighted_tracts, by=list(SSN=urban$SSN), FUN=sum)
mun_type1 <- rename(mun_type1, urban = x)

mun_type1 <- left_join(mun_tracts, mun_type1, by = "SSN")

mun_type1$rate_urb <- mun_type1$urban / mun_type1$area_total
mun_type1$urban = NULL
mun_type1$area_total = NULL

mun_type1$rate_urb[is.na(mun_type1$rate_urb)] <- 0


# gen type 2

suburb <- subset(merge, num_type == "2")


#merge$type_2 <- ifelse(merge$type == '2', 1, 0)

mun_type2 <- aggregate(suburb$weighted_tracts, by=list(SSN=suburb$SSN), FUN=sum)
mun_type2 <- rename(mun_type2, suburban = x)

mun_type2 <- left_join(mun_tracts, mun_type2, by = "SSN")

mun_type2$rate_sub <- mun_type2$suburban / mun_type2$area_total
mun_type2$suburban = NULL
mun_type2$area_total = NULL


mun_type2$rate_sub[is.na(mun_type2$rate_sub)] <- 0



# gen type 3

ex <- subset(merge, num_type == "3")


#merge$type_3 <- ifelse(merge$type == '3', 1, 0)

mun_type3 <- aggregate(ex$weighted_tracts, by=list(SSN=ex$SSN), FUN=sum)
mun_type3 <- rename(mun_type3, exurban = x)

mun_type3 <- left_join(mun_tracts, mun_type3, by = "SSN")

mun_type3$rate_ex <- mun_type3$exurban / mun_type3$area_total
mun_type3$exurban = NULL
mun_type3$area_total = NULL

mun_type3$rate_ex[is.na(mun_type3$rate_ex)] <- 0


# gen type 4

town <- subset(merge, num_type == "4")


#merge$type_4 <- ifelse(merge$type == '4', 1, 0)

mun_type4 <- aggregate(town$weighted_tracts, by=list(SSN=town$SSN), FUN=sum)
mun_type4 <- rename(mun_type4, town = x)

mun_type4 <- left_join(mun_tracts, mun_type4, by = "SSN")

mun_type4$rate_town <- mun_type4$town / mun_type4$area_total
mun_type4$town = NULL
mun_type4$area_total = NULL

mun_type4$rate_town[is.na(mun_type4$rate_town)] <- 0

# gen type 5

rural <- subset(merge, num_type == 5)


#merge$type_5 <- ifelse(merge$type == 5, 1, 0)

mun_type5 <- aggregate(rural$weighted_tracts, by=list(SSN=rural$SSN), FUN=sum)
mun_type5 <- rename(mun_type5, rural = x)

mun_type5 <- left_join(mun_tracts, mun_type5, by = "SSN")

mun_type5$rate_rur <- mun_type5$rural / mun_type5$area_total
mun_type5$rural = NULL
mun_type5$area_total = NULL

mun_type5$rate_rur[is.na(mun_type5$rate_rur)] <- 0



##### merge

percent_mun_type <- merge(mun_type1, mun_type2, by = "SSN")
percent_mun_type <- merge(percent_mun_type, mun_type3, by = "SSN")
percent_mun_type <- merge(percent_mun_type, mun_type4, by = "SSN")
percent_mun_type <- merge(percent_mun_type, mun_type5, by = "SSN")

geo <- nj_municipal[c("SSN", "geometry")]

percent_mun_type <- merge(percent_mun_type, geo, by = "SSN")

#
sub <- c("rate_urb", "rate_sub", "rate_ex", "rate_town", "rate_rur")

mun_sub <- percent_mun_type[sub]

percent_mun_type$max <- colnames(mun_sub)[max.col(mun_sub, ties.method = "first")]

# names

percent_mun_type$max[which(percent_mun_type$max == "rate_urb")] = "Urban"
percent_mun_type$max[which(percent_mun_type$max == "rate_sub")] = "Suburb"
percent_mun_type$max[which(percent_mun_type$max == "rate_ex")] = "Exurban"
percent_mun_type$max[which(percent_mun_type$max == "rate_town")] = "Town"
percent_mun_type$max[which(percent_mun_type$max == "rate_rur")] = "Rural"


#percent_mun_type$majority <- ifelse(percent_mun_type$rate_urb > percent_mun_type$rate_sub & 
#                                      percent_mun_type$rate_urb > percent_mun_type$rate_rur, 1, 
#                                    ifelse(percent_mun_type$rate_sub > percent_mun_type$rate_rur, 2, 3))


#percent_mun_type$validation <- percent_mun_type$rate_urb + percent_mun_type$rate_sub + percent_mun_type$rate_rur

#save

setwd("~/Documents/HEROP")
st_write(percent_mun_type,"2_type_ratio2.shp", driver = "ESRI Shapefile", append = TRUE)


######## all tract RUCA

tract_RUCA <- merge(tract_areas, class, by = "TRACTID")







######################################################################### SD

####################################### Method 1 - average


## agg

mun_SD <- aggregate(merge$num_SD, by=list(SSN=merge$SSN), FUN=mean)
mun_SD <- rename(mun_SD, SD = x)
mun_SD$SD <- round(mun_SD$SD ,0)

# names
mun_SD$name <- mun_SD$SD

mun_SD$name[which(mun_SD$name == 1)] = "High Density Urban"
mun_SD$name[which(mun_SD$name == 2)] = "Medium Density Urban"
mun_SD$name[which(mun_SD$name == 3)] = "Suburban"
mun_SD$name[which(mun_SD$name == 4)] = "Exurban"
mun_SD$name[which(mun_SD$name == 5)] = "rural"


#merge

class_shp <- merge(new, mun_SD, by = "SSN")

setwd("~/Documents/HEROP")
st_write(class_shp,"2_SD_avg.shp", driver = "ESRI Shapefile", append = TRUE)


############################################### SD 2 --- Mode

## agg

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}


mun_SD2 <- aggregate(merge$num_SD, by=list(SSN=merge$SSN), FUN=Mode)
mun_SD2 <- rename(mun_SD2, SD = x)


## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")


sub <- c("SSN", "geometry")

new2 <- nj_municipal[sub]

new2$SSN <- as.numeric(new2$SSN)

# names
mun_SD2$name <- mun_SD2$SD

mun_SD2$name[which(mun_SD2$name == 1)] = "High Density Urban"
mun_SD2$name[which(mun_SD2$name == 2)] = "Medium Density Urban"
mun_SD2$name[which(mun_SD2$name == 3)] = "Suburban"
mun_SD2$name[which(mun_SD2$name == 4)] = "Exurban"
mun_SD2$name[which(mun_SD2$name == 5)] = "rural"



#merge

class_shp2 <- merge(new2, mun_SD2, by = "SSN")

setwd("~/Documents/HEROP")
st_write(class_shp2,"2_SD_mode.shp", driver = "ESRI Shapefile", append = TRUE)



############################ SD 3 - land distribution


areas <- nj_municipal[c("SSN", "SQ_MILES")]
areas$geometry = NULL
areas$SSN <- as.numeric(areas$SSN)


method3 <- merge(merge, areas, by = "SSN")

method3$weight = method3$prop_of_ct * method3$SQ_MILES

library(data.table)

SDs3 <- setDT(method3)[, .SD[which.max(SQ_MILES)], by=SSN]

SDs3$Place.Name <- NULL
SDs3$TRACTID <- NULL
SDs3$prop_of_ct <- NULL
SDs3$SD <- NULL
SDs3$SD <- NULL
SDs3$num_SD <- NULL
SDs3$SQ_MILES <- NULL
SDs3$weight <- NULL


geo <- new[c("SSN", "geometry")]

class_shp3 <- merge(geo, SDs3, by = "SSN")

# names
mun_SD$name <- mun_SD$SD

mun_SD$name[which(mun_SD$name == 1)] = "High Density Urban"
mun_SD$name[which(mun_SD$name == 2)] = "Medium Density Urban"
mun_SD$name[which(mun_SD$name == 3)] = "Suburban"
mun_SD$name[which(mun_SD$name == 4)] = "Exurban"
mun_SD$name[which(mun_SD$name == 5)] = "rural"





#save

setwd("~/Documents/HEROP")
st_write(class_shp3,"2_SD_max.shp", driver = "ESRI Shapefile", append = TRUE)

############################ SD 4 - percentage of each SD (# / total tracts)


## make tally of total tracts in municipality
## total sum of each SD of geog by municipality
## agg on those

## dummy total
merge$tracts <- 1

mun_tracts <- aggregate(merge$tracts, by=list(SSN=merge$SSN), FUN=sum)
mun_tracts <- rename(mun_tracts, num_tracts = x)

# gen SD 1
merge$SD_1 <- ifelse(merge$num_SD == '1', 1, 0)

mun_SD1 <- aggregate(merge$SD_1, by=list(SSN=merge$SSN), FUN=sum)
mun_SD1 <- rename(mun_SD1, hi_dens = x)
mun_SD1$rate_hi <- mun_SD1$hi_dens / mun_tracts$num_tracts
mun_SD1$hi_dens = NULL

# gen SD 2
merge$SD_2 <- ifelse(merge$num_SD == '2', 1, 0)

mun_SD2 <- aggregate(merge$SD_2, by=list(SSN=merge$SSN), FUN=sum)
mun_SD2 <- rename(mun_SD2, low_dens = x)
mun_SD2$rate_low <- mun_SD2$low_dens / mun_tracts$num_tracts
mun_SD2$low_dens = NULL


# gen SD 3
merge$SD_3 <- ifelse(merge$num_SD == '3', 1, 0)

mun_SD3 <- aggregate(merge$SD_3, by=list(SSN=merge$SSN), FUN=sum)
mun_SD3 <- rename(mun_SD3, suburban = x)
mun_SD3$rate_sub <- mun_SD3$suburban / mun_tracts$num_tracts
mun_SD3$suburban = NULL


# gen SD 4
merge$SD_4 <- ifelse(merge$num_SD == '4', 1, 0)

mun_SD4 <- aggregate(merge$SD_4, by=list(SSN=merge$SSN), FUN=sum)
mun_SD4 <- rename(mun_SD4, exurban = x)
mun_SD4$rate_ex <- mun_SD4$exurban / mun_tracts$num_tracts
mun_SD4$exurban = NULL



# gen SD 5
merge$SD_5 <- ifelse(merge$num_SD == '5', 1, 0)

mun_SD5 <- aggregate(merge$SD_5, by=list(SSN=merge$SSN), FUN=sum)
mun_SD5 <- rename(mun_SD5, rural = x)
mun_SD5$rate_rur <- mun_SD5$rural / mun_tracts$num_tracts
mun_SD5$rural = NULL



##### merge

percent_mun_SD <- merge(mun_SD1, mun_SD2, by = "SSN")
percent_mun_SD <- merge(percent_mun_SD, mun_SD3, by = "SSN")
percent_mun_SD <- merge(percent_mun_SD, mun_SD4, by = "SSN")
percent_mun_SD <- merge(percent_mun_SD, mun_SD5, by = "SSN")

geo <- nj_municipal[c("SSN", "geometry")]

percent_mun_SD <- merge(percent_mun_SD, geo, by = "SSN")

sub <- c("rate_hi", "rate_low", "rate_sub", "rate_ex", "rate_rur")

mun_sub <- percent_mun_SD[sub]

percent_mun_SD$max <- colnames(mun_sub)[max.col(mun_sub, ties.method = "first")]

# names

percent_mun_SD$max[which(percent_mun_SD$max == "rate_hi")] = "High Density Urban"
percent_mun_SD$max[which(percent_mun_SD$max == "rate_low")] = "Medium Density Urban"
percent_mun_SD$max[which(percent_mun_SD$max == "rate_sub")] = "Suburban"
percent_mun_SD$max[which(percent_mun_SD$max == "rate_ex")] = "Exurban"
percent_mun_SD$max[which(percent_mun_SD$max == "rate_rur")] = "rural"




#percent_mun_SD$majority <- ifelse(percent_mun_SD$rate_urb > percent_mun_SD$rate_sub & 
#                                      percent_mun_SD$rate_urb > percent_mun_SD$rate_rur, 1, 
#                                    ifelse(percent_mun_SD$rate_sub > percent_mun_SD$rate_rur, 2, 3))




### for somer reason this is not perfect

#ifelse(percent_mun_SD$rate_urb > percent_mun_SD$rate_sub, 1, ifelse(percent_mun_SD$rate_sub > percent_mun_SD$rate_rur, 2, 3))


#save

setwd("~/Documents/HEROP")
st_write(percent_mun_SD,"2_SD_ratio.shp", driver = "ESRI Shapefile", append = TRUE)



############################ SD 5 - area percentage of each SD (area of SD / area)

## New Jersey Tracts
setwd("~/Documents/HEROP/tl_2018_34_tract")
nj_tract <- read_sf("tl_2018_34_tract.shp")

tract_areas <- nj_tract %>% 
  mutate(tract_area = st_area(nj_tract$geometry))

tract_areas$tract_area <- drop_units(tract_areas$tract_area)
tract_areas <- rename(tract_areas, TRACTID = GEOID)

tract_areas_new <- tract_areas[c("TRACTID", "tract_area")]
tract_areas_new$geometry = NULL

merge <- merge(merge, tract_areas_new, by = "TRACTID")


## make tally of total tracts in municipality
## total sum of each SD of geog by municipality
## agg on those





## area total
merge$weighted_tracts <- merge$prop_of_ct * merge$tract_area

mun_tracts <- aggregate(merge$weighted_tracts, by=list(SSN=merge$SSN), FUN=sum)
mun_tracts <- rename(mun_tracts, area_total = x)

# gen SD 1

hi_dens <- subset(merge, num_SD == "1")


#hi_dens$SD_1 <- ifelse(merge$SD == '1', merge$tract_area, 0)

mun_SD1 <- aggregate(hi_dens$weighted_tracts, by=list(SSN=hi_dens$SSN), FUN=sum)
mun_SD1 <- rename(mun_SD1, hi_dens = x)

mun_SD1 <- left_join(mun_tracts, mun_SD1, by = "SSN")

mun_SD1$rate_hi <- mun_SD1$hi_dens / mun_SD1$area_total
mun_SD1$hi_dens = NULL
mun_SD1$area_total = NULL

mun_SD1$rate_hi[is.na(mun_SD1$rate_hi)] <- 0


# gen SD 2

low_dens <- subset(merge, num_SD == "2")


#merge$SD_2 <- ifelse(merge$SD == '2', 1, 0)

mun_SD2 <- aggregate(low_dens$weighted_tracts, by=list(SSN=low_dens$SSN), FUN=sum)
mun_SD2 <- rename(mun_SD2, low_dens = x)

mun_SD2 <- left_join(mun_tracts, mun_SD2, by = "SSN")

mun_SD2$rate_low <- mun_SD2$low_dens / mun_SD2$area_total
mun_SD2$low_dens = NULL
mun_SD2$area_total = NULL


mun_SD2$rate_low[is.na(mun_SD2$rate_low)] <- 0



# gen SD 3

sub <- subset(merge, num_SD == "3")


#merge$SD_3 <- ifelse(merge$SD == '3', 1, 0)

mun_SD3 <- aggregate(sub$weighted_tracts, by=list(SSN=sub$SSN), FUN=sum)
mun_SD3 <- rename(mun_SD3, suburban = x)

mun_SD3 <- left_join(mun_tracts, mun_SD3, by = "SSN")

mun_SD3$rate_sub <- mun_SD3$suburban / mun_SD3$area_total
mun_SD3$suburban = NULL
mun_SD3$area_total = NULL

mun_SD3$rate_sub[is.na(mun_SD3$rate_sub)] <- 0


# gen SD 4

exurban <- subset(merge, num_SD == "4")


#merge$SD_4 <- ifelse(merge$SD == '4', 1, 0)

mun_SD4 <- aggregate(exurban$weighted_tracts, by=list(SSN=exurban$SSN), FUN=sum)
mun_SD4 <- rename(mun_SD4, exurban = x)

mun_SD4 <- left_join(mun_tracts, mun_SD4, by = "SSN")

mun_SD4$rate_ex <- mun_SD4$exurban / mun_SD4$area_total
mun_SD4$exurban = NULL
mun_SD4$area_total = NULL

mun_SD4$rate_ex[is.na(mun_SD4$rate_ex)] <- 0

# gen SD 5

rural <- subset(merge, num_SD == 5)


#merge$SD_5 <- ifelse(merge$SD == 5, 1, 0)

mun_SD5 <- aggregate(rural$weighted_tracts, by=list(SSN=rural$SSN), FUN=sum)
mun_SD5 <- rename(mun_SD5, rural = x)

mun_SD5 <- left_join(mun_tracts, mun_SD5, by = "SSN")

mun_SD5$rate_rur <- mun_SD5$rural / mun_SD5$area_total
mun_SD5$rural = NULL
mun_SD5$area_total = NULL

mun_SD5$rate_rur[is.na(mun_SD5$rate_rur)] <- 0



##### merge

percent_mun_SD <- merge(mun_SD1, mun_SD2, by = "SSN")
percent_mun_SD <- merge(percent_mun_SD, mun_SD3, by = "SSN")
percent_mun_SD <- merge(percent_mun_SD, mun_SD4, by = "SSN")
percent_mun_SD <- merge(percent_mun_SD, mun_SD5, by = "SSN")

geo <- nj_municipal[c("SSN", "geometry")]

percent_mun_SD <- merge(percent_mun_SD, geo, by = "SSN")

#
sub <- c("rate_hi", "rate_low", "rate_sub", "rate_ex", "rate_rur")

mun_sub <- percent_mun_SD[sub]

percent_mun_SD$max <- colnames(mun_sub)[max.col(mun_sub, ties.method = "first")]

# names

percent_mun_SD$max[which(percent_mun_SD$max == "rate_hi")] = "High Density Urban"
percent_mun_SD$max[which(percent_mun_SD$max == "rate_low")] = "Medium Density Urban"
percent_mun_SD$max[which(percent_mun_SD$max == "rate_sub")] = "Suburban"
percent_mun_SD$max[which(percent_mun_SD$max == "rate_ex")] = "Exurban"
percent_mun_SD$max[which(percent_mun_SD$max == "rate_rur")] = "Rural"


#percent_mun_SD$majority <- ifelse(percent_mun_SD$rate_urb > percent_mun_SD$rate_sub & 
#                                      percent_mun_SD$rate_urb > percent_mun_SD$rate_rur, 1, 
#                                    ifelse(percent_mun_SD$rate_sub > percent_mun_SD$rate_rur, 2, 3))


#percent_mun_SD$validation <- percent_mun_SD$rate_urb + percent_mun_SD$rate_sub + percent_mun_SD$rate_rur

#save

setwd("~/Documents/HEROP")
st_write(percent_mun_SD,"2_SD_ratio2.shp", driver = "ESRI Shapefile", append = TRUE)




