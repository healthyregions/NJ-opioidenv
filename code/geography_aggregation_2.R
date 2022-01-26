### residential foreclosures

#read geography data

setwd("~/Documents/HEROP/new geography type/new geog")
geog_data <- read.csv("New Jersey-Table 1.csv")

## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")
nj_municipal$SSN <- as.numeric(nj_municipal$SSN)


sub <- c("SSN", "geometry")

new <- nj_municipal[sub]

new$SSN <- as.numeric(new$SSN)


##clean geog data
keep <- c("TRACTID", "reclass")
geog <- geog_data[keep]

#type
geog$num_type <- geog$reclass

geog$num_type[which(geog$num_type == "Urban")] = 1
geog$num_type[which(geog$num_type == "Suburb")] = 2
geog$num_type[which(geog$num_type == "Suburban")] = 2
geog$num_type[which(geog$num_type == "Rural")] = 3


geog$num_type <- as.numeric(as.character(geog$num_type))



## read cw
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")

### merge
merge <- left_join(cw, geog, by = "TRACTID")

merge <- merge[complete.cases(merge), ]


####################################### Method 1 - average


## agg

mun_type <- aggregate(merge$num_type, by=list(SSN=merge$SSN), FUN=mean)
mun_type <- rename(mun_type, type = x)
mun_type$type <- round(mun_type$type ,0)

# names
mun_type$name <- mun_type$type

mun_type$name[which(mun_type$name == 1)] = "Urban"
mun_type$name[which(mun_type$name == 2)] = "Suburb"
mun_type$name[which(mun_type$name == 2)] = "Suburban"
mun_type$name[which(mun_type$name == 3)] = "Rural"


#merge

class_shp <- merge(new, mun_type, by = "SSN")

subset_NJgeog <- nj_municipal[c("SSN", "MUN")]
subset_NJgeog$geometry = NULL

class_shp <- merge(class_shp, subset_NJgeog, by = "SSN")

class_shp$rand <- sample(1:15, 565, replace=T)


setwd("~/Documents/HEROP/new geography type")
st_write(class_shp,"3_type_avg.shp", driver = "ESRI Shapefile", append = TRUE)


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
mun_type2$name[which(mun_type2$name == 2)] = "Suburban"
mun_type2$name[which(mun_type2$name == 3)] = "Rural"


#merge

class_shp2 <- merge(new2, mun_type2, by = "SSN")
class_shp2 <- merge(class_shp2, subset_NJgeog, by = "SSN")

class_shp2$rand <- class_shp$rand

setwd("~/Documents/HEROP")
st_write(class_shp2,"3_type_mode.shp", driver = "ESRI Shapefile", append = TRUE)



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
types3$reclass <- NULL
types3$SQ_MILES <- NULL
types3$weight <- NULL


geo <- new[c("SSN", "geometry")]

class_shp3 <- merge(geo, types3, by = "SSN")

# names
mun_type$name <- mun_type$type
class_shp3$rand <- class_shp$rand

mun_type$name[which(mun_type$name == 1)] = "Urban"
mun_type$name[which(mun_type$name == 2)] = "Suburb"
mun_type$name[which(mun_type$name == 2)] = "Suburban"
mun_type$name[which(mun_type$name == 3)] = "Rural"



#save

setwd("~/Documents/HEROP")
st_write(class_shp3,"3_type_max.shp", driver = "ESRI Shapefile", append = TRUE)

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
mun_type3 <- rename(mun_type3, rural = x)
mun_type3$rate_rur <- mun_type3$rural / mun_tracts$num_tracts
mun_type3$rural = NULL



##### merge

percent_mun_type4 <- merge(mun_type1, mun_type2, by = "SSN")
percent_mun_type4 <- merge(percent_mun_type4, mun_type3, by = "SSN")

geo <- nj_municipal[c("SSN", "geometry")]
geo$SSN <- as.numeric(geo$SSN)

percent_mun_type4 <- merge(percent_mun_type4, geo, by = "SSN")

sub <- c("rate_urb", "rate_sub", "rate_rur")

mun_sub <- percent_mun_type4[sub]

percent_mun_type4$max <- colnames(mun_sub)[max.col(mun_sub, ties.method = "first")]

# names

percent_mun_type4$max[which(percent_mun_type4$max == "rate_urb")] = "Urban"
percent_mun_type4$max[which(percent_mun_type4$max == "rate_sub")] = "Suburb"
percent_mun_type4$max[which(percent_mun_type4$max == "rate_rur")] = "Rural"

percent_mun_type4 <- merge(percent_mun_type4, subset_NJgeog, by = "SSN")

percent_mun_type4$rand <- class_shp$rand


#percent_mun_type$majority <- ifelse(percent_mun_type$rate_urb > percent_mun_type$rate_sub & 
#                                      percent_mun_type$rate_urb > percent_mun_type$rate_rur, 1, 
#                                    ifelse(percent_mun_type$rate_sub > percent_mun_type$rate_rur, 2, 3))




### for somer reason this is not perfect

#ifelse(percent_mun_type$rate_urb > percent_mun_type$rate_sub, 1, ifelse(percent_mun_type$rate_sub > percent_mun_type$rate_rur, 2, 3))


#save

setwd("~/Documents/HEROP")
st_write(percent_mun_type4,"3_type_ratio.shp", driver = "ESRI Shapefile", append = TRUE)



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

rural <- subset(merge, num_type == 3)


#merge$type_5 <- ifelse(merge$type == 3, 1, 0)

mun_type3 <- aggregate(rural$weighted_tracts, by=list(SSN=rural$SSN), FUN=sum)
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
geo$SSN <- as.numeric(geo$SSN)

percent_mun_type <- merge(percent_mun_type, geo, by = "SSN")

#
sub <- c("rate_urb", "rate_sub", "rate_rur")

mun_sub <- percent_mun_type[sub]

percent_mun_type$max <- colnames(mun_sub)[max.col(mun_sub, ties.method = "first")]

# names

percent_mun_type$max[which(percent_mun_type$max == "rate_urb")] = "Urban"
percent_mun_type$max[which(percent_mun_type$max == "rate_sub")] = "Suburb"
percent_mun_type$max[which(percent_mun_type$max == "rate_rur")] = "Rural"

percent_mun_type <- merge(percent_mun_type, subset_NJgeog, by = "SSN")
percent_mun_type$rand <- class_shp$rand

#percent_mun_type$majority <- ifelse(percent_mun_type$rate_urb > percent_mun_type$rate_sub & 
#                                      percent_mun_type$rate_urb > percent_mun_type$rate_rur, 1, 
#                                    ifelse(percent_mun_type$rate_sub > percent_mun_type$rate_rur, 2, 3))


#percent_mun_type$validation <- percent_mun_type$rate_urb + percent_mun_type$rate_sub + percent_mun_type$rate_rur

#save

setwd("~/Documents/HEROP")
st_write(percent_mun_type,"3_type_ratio2.shp", driver = "ESRI Shapefile", append = TRUE)


######## all tract RUCA

tract_RUCA <- merge(tract_areas, class, by = "TRACTID")




mun_classifications = NULL

mun_classifications <- class_shp
mun_classifications <- rename(mun_classifications, avg = type)
mun_classifications$geometry = NULL
mun_classifications$name = NULL
mun_classifications$MUN = NULL
mun_classifications$rand= NULL

mun_classifications <- merge(mun_classifications, class_shp2, by = "SSN")
mun_classifications <- rename(mun_classifications, mode = type)
mun_classifications$geometry = NULL
mun_classifications$name = NULL
mun_classifications$MUN = NULL
mun_classifications$rand= NULL

mun_classifications <- merge(mun_classifications, percent_mun_type, by = "SSN")
mun_classifications <- rename(mun_classifications, area_ratio = max)
mun_classifications$rate_urb <- NULL
mun_classifications$rate_sub <- NULL
mun_classifications$rate_rur <- NULL 

mun_classifications$name[which(mun_classifications$area_ratio == "Urban")] = 1
mun_classifications$name[which(mun_classifications$area_ratio == "Suburb")] = 2
mun_classifications$name[which(mun_classifications$area_ratio == "Rural")] = 3

mun_classifications$rand = NULL
mun_classifications$max = NULL
mun_classifications$geometry = NULL
mun_classifications$area_ratio = NULL

mun_classifications <- rename(mun_classifications, area_ratio = name)

setwd("~/Documents/HEROP")
write.csv(mun_classifications, "mun_classifications.csv")











library(readxl)
setwd("~/Documents/HEROP/new geography type")
mun_landclass_final <- read_excel("mun_landclass_final.xlsx")

mun_landclass_final$...1 = NULL
mun_landclass_final$rand = percent_mun_type$rand
mun_landclass_final <- rename(mun_landclass_final, SSN = SSN_MunCode)
mun_landclass_final <- rename(mun_landclass_final, value = MunLand_class_value)
mun_landclass_final <- rename(mun_landclass_final, classname = MunLand_class_name)

mun_landclass_final <- merge(mun_landclass_final, new, by = "SSN")


setwd("~/Documents/HEROP/new geography type")
st_write(mun_landclass_final,"mun_landclass_final_sf", driver = "ESRI Shapefile", append = TRUE)


