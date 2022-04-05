# Data Cleaning 

#install.packages("scales")

library(scales)
library(sf)
library(tmap)
library(dplyr)


#### DATA CLEANING ##########

# load master abridged

setwd("~/Code/NJ-opioidenv/data_final")
#setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master.all <- read.csv("master(no_index).csv")
master.all$SSN <- as.integer((as.character(master.all$SSN)))

#pubTransRt
#noVhcleRt
#multiUnRt
#hs20yrRt

master.geo <- st_read("master_geog.geojson")
masterSF <- subset(master.geo[,c("Place.Name","SSN")])
masterSF$SSN <- as.integer((as.character(masterSF$SSN)))
masterSF <- left_join(masterSF, master.all, by = "SSN")

st_crs(masterSF) #EPSG is 3424, in feet
masterSF$areaFt <- st_area(masterSF)
masterSF$areaMi <- masterSF$areaFt * 0.000189394  #to miles
head(masterSF)

library(tmap)
tm_shape(masterSF) + tm_polygons("areaMi")


#calc business density (number of business per area)
masterSF$bizDens <- masterSF$bizNum / masterSF$areaMi
tm_shape(masterSF) + tm_fill("bizDens", style = "jenks", n = 6) 

#calc average vacant business rate
masterSF$avgVacBizRt <- masterSF$avgVacBiz / masterSF$bizNum
tm_shape(masterSF) + tm_fill("avgVacBiz", style = "jenks", n = 6)
tm_shape(masterSF) + tm_fill("avgVacBiz", style = "jenks", n = 6)


#calc path density
masterSF$allPathsMi <- masterSF$allPaths * 0.000189394 # to miles 
masterSF$pathsDens <- masterSF$allPaths / masterSF$areaMi
tm_shape(masterSF) + tm_fill("pathsDens", style = "jenks", n = 6)

#Schools per person?! 
tm_shape(masterSF) + tm_fill("schoolPPop", style = "jenks", n = 6)

#ageCt?
tm_shape(masterSF) + tm_fill("ageCt", style = "jenks", n = 6)


head(masterSF)


masterSF$opDtRt1518 <- masterSF$opDtRt1518/5
masterSF$opDtRt1518ave  <- masterSF$opDtRt1518
masterSF$opDt1518sum <- masterSF$opDt15 + masterSF$opDt16 + 
    masterSF$opDt17 + masterSF$opDt18 

#pubTransRt
#noVhcleRt
#multiUnRt
#hs20yrRt


master.all <- masterSF

masterSF$alcLicMi <- masterSF$alcLicKm2 * 0.621371
tm_shape(masterSF) + tm_fill("alcLicMi", style = "jenks", n = 6) 


tm_shape(masterSF) + tm_fill("crowdedPct", style = "jenks", n = 6) 


masterSF$popDens17 <- (masterSF$pop2017 / masterSF$areaMi)

#missing: adultPop

tm_shape(masterSF) + tm_fill("pubTransRt", style = "jenks", n = 6) 


# Reorganize according to data dictionary 

masterNew <- subset(masterSF[,c("SSN", "municipality", "pop2017", "areaMi",
                                "alcLicMi", "noVhcleRt", "pubTransRt","avgVacBiz", "bizDens",
                                "syrngDist", "naloxDist", "moudDist", "sutDist", "mentHlDist",
                                "HDensRes", "parksProp", "allPaths", "ndvi", "resPctTot", 
                                "comPctTot", "indPctTot",
                                "schoolPPop", "multiUnRt", "occRate", "mblHomePct", 
                                "avgPropTax", "hs20yrRt", "rentPct", "medRent", 
                                "medHValue", "burdenPct", "crowdedPct", "frClsRtMrt",
                                "empPerCap", "incPerCap", "snapP", "govExp",
                                "adultEdDst", "cultrDist", "voluntrOp",
                                "isoAsian", "isoBlack", "isoHisp", "SVIthemes",
                                "mriScore", "landUseClass", "popDens17", 
                                "hsGradRt", "vlntCrRt",
                                "opDtRt15", "opDtRt16", "opDtRt17", "opDtRt18", "opDtRt1518ave",
                                "opDt15", "opDt16","opDt17", "opDt18", "opDt1518sum")])

masterNew$HDensRes <-  masterNew$HDensRes * 100

write_sf(masterNew, "NJMaster.shp")
write_sf(masterNew, "NJMaster.geojson")
              
masterNewCSV <- st_drop_geometry(masterNew)

write.csv(masterNewCSV, "NJMaster.csv")

