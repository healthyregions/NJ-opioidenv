
### Rurality

## rurality
setwd("~/Documents/HEROP")
class <- read.csv("UrbanSubRural_T.csv")

class$type <- class$RUCA1

class$type <- ifelse(class$RUCA1>3, 3, class$RUCA1)
class <- rename(class, TRACTID = tractFIPS)


### Read in crosswalk

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")

## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")
nj_municipal$SSN <- as.numeric(nj_municipal$SSN)

### Left Join

merge <- left_join(cw, class, by = "TRACTID")


## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")
nj_municipal$SSN <- as.numeric(nj_municipal$SSN)


sub <- c("SSN", "geometry")

new <- nj_municipal[sub]

new$SSN <- as.numeric(new$SSN)



####################################### Method 1 - average


## agg

mun_type <- aggregate(merge$type, by=list(SSN=merge$SSN), FUN=mean)
mun_type <- rename(mun_type, type = x)

mun_type$type <- round(mun_type$type ,0)




#merge

class_shp <- merge(new, mun_type, by = "SSN")

setwd("~/Documents/HEROP")
st_write(class_shp,"mun_type_avg.shp", driver = "ESRI Shapefile", append = TRUE)


############################################### Type 2 --- Mode

## agg

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}


mun_type2 <- aggregate(merge$type, by=list(SSN=merge$SSN), FUN=Mode)
mun_type2 <- rename(mun_type2, type = x)


## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")


sub <- c("SSN", "geometry")

new2 <- nj_municipal[sub]

new2$SSN <- as.numeric(new2$SSN)


#merge

class_shp2 <- merge(new2, mun_type2, by = "SSN")

setwd("~/Documents/HEROP")
st_write(class_shp2,"mun_type_mode.shp", driver = "ESRI Shapefile", append = TRUE)



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
types3$RUCA1 <- NULL
types3$RUCA2 <- NULL
types3$rurality <- NULL
types3$SQ_MILES <- NULL
types3$weight <- NULL


geo <- nj_municipal[c("SSN", "geometry")]

class_shp3 <- merge(geo, types3, by = "SSN")

#save

setwd("~/Documents/HEROP")
st_write(class_shp3,"mun_type_max.shp", driver = "ESRI Shapefile", append = TRUE)

############################ type 4 - percentage of each type


## make tally of total tracts in municipality
## total sum of each type of geog by municipality
## agg on those

## dummy total
merge$tracts <- 1

mun_tracts <- aggregate(merge$tracts, by=list(SSN=merge$SSN), FUN=sum)
mun_tracts <- rename(mun_tracts, num_tracts = x)

# gen type 1
merge$type_1 <- ifelse(merge$type == '1', 1, 0)

mun_type1 <- aggregate(merge$type_1, by=list(SSN=merge$SSN), FUN=sum)
mun_type1 <- rename(mun_type1, urban = x)
mun_type1$rate_urb <- mun_type1$urban / mun_tracts$num_tracts
mun_type1$urban = NULL

# gen type 2
merge$type_2 <- ifelse(merge$type == '2', 1, 0)

mun_type2 <- aggregate(merge$type_2, by=list(SSN=merge$SSN), FUN=sum)
mun_type2 <- rename(mun_type2, suburban = x)
mun_type2$rate_sub <- mun_type2$suburban / mun_tracts$num_tracts
mun_type2$suburban = NULL


# gen type 3
merge$type_3 <- ifelse(merge$type == '3', 1, 0)

mun_type3 <- aggregate(merge$type_3, by=list(SSN=merge$SSN), FUN=sum)
mun_type3 <- rename(mun_type3, rural = x)
mun_type3$rate_rur <- mun_type3$rural / mun_tracts$num_tracts
mun_type3$rural = NULL


##### merge

percent_mun_type <- merge(mun_type1, mun_type2, by = "SSN")
percent_mun_type <- merge(percent_mun_type, mun_type3, by = "SSN")

geo <- nj_municipal[c("SSN", "geometry")]

percent_mun_type <- merge(percent_mun_type, geo, by = "SSN")


percent_mun_type$majority <- ifelse(percent_mun_type$rate_urb > percent_mun_type$rate_sub & 
                                    percent_mun_type$rate_urb > percent_mun_type$rate_rur, 1, 
                                  ifelse(percent_mun_type$rate_sub > percent_mun_type$rate_rur, 2, 3))




### for somer reason this is not perfect

#ifelse(percent_mun_type$rate_urb > percent_mun_type$rate_sub, 1, ifelse(percent_mun_type$rate_sub > percent_mun_type$rate_rur, 2, 3))


#save

setwd("~/Documents/HEROP")
st_write(percent_mun_type,"mun_type_ratio.shp", driver = "ESRI Shapefile", append = TRUE)



############################ type 5 - area percentage of each type

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

RUCA1 <- subset(merge, type == "1")


#RUCA1$type_1 <- ifelse(merge$type == '1', merge$tract_area, 0)

mun_type1 <- aggregate(RUCA1$weighted_tracts, by=list(SSN=RUCA1$SSN), FUN=sum)
mun_type1 <- rename(mun_type1, urban = x)

mun_type1 <- left_join(mun_tracts, mun_type1, by = "SSN")
  
mun_type1$rate_urb <- mun_type1$urban / mun_type1$area_total
mun_type1$urban = NULL
mun_type1$area_total = NULL

mun_type1$rate_urb[is.na(mun_type1$rate_urb)] <- 0


# gen type 2

RUCA2 <- subset(merge, type == "2")


#merge$type_2 <- ifelse(merge$type == '2', 1, 0)

mun_type2 <- aggregate(RUCA2$weighted_tracts, by=list(SSN=RUCA2$SSN), FUN=sum)
mun_type2 <- rename(mun_type2, suburban = x)

mun_type2 <- left_join(mun_tracts, mun_type2, by = "SSN")

mun_type2$rate_sub <- mun_type2$suburban / mun_type2$area_total
mun_type2$suburban = NULL
mun_type2$area_total = NULL


mun_type2$rate_sub[is.na(mun_type2$rate_sub)] <- 0



# gen type 3

RUCA3 <- subset(merge, type == "3")


merge$type_3 <- ifelse(merge$type == '3', 1, 0)

mun_type3 <- aggregate(merge$type_3, by=list(SSN=merge$SSN), FUN=sum)
mun_type3 <- rename(mun_type3, rural = x)

mun_type3 <- left_join(mun_tracts, mun_type3, by = "SSN")

mun_type3$rate_rur <- mun_type3$rural / mun_type3$area_total
mun_type3$rural = NULL
mun_type3$area_total = NULL

mun_type3$rate_rur[is.na(mun_type3$rate_rur)] <- 0

##### merge

percent_mun_type <- merge(mun_type1, mun_type2, by = "SSN")
percent_mun_type <- merge(percent_mun_type, mun_type3, by = "SSN")

geo <- nj_municipal[c("SSN", "geometry")]

percent_mun_type <- merge(percent_mun_type, geo, by = "SSN")


percent_mun_type$majority <- ifelse(percent_mun_type$rate_urb > percent_mun_type$rate_sub & 
                                    percent_mun_type$rate_urb > percent_mun_type$rate_rur, 1, 
                                  ifelse(percent_mun_type$rate_sub > percent_mun_type$rate_rur, 2, 3))


percent_mun_type$validation <- percent_mun_type$rate_urb + percent_mun_type$rate_sub + percent_mun_type$rate_rur

#save

setwd("~/Documents/HEROP")
st_write(percent_mun_type,"mun_type_ratio2.shp", driver = "ESRI Shapefile", append = TRUE)


######## all tract RUCA

tract_RUCA <- merge(tract_areas, class, by = "TRACTID")

#save

setwd("~/Documents/HEROP")
st_write(tract_RUCA,"tract_class.shp", driver = "ESRI Shapefile", append = TRUE)


