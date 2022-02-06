#INDEX

#install.packages("scales")

library(scales)
library(sf)
library(tmap)
library(dplyr)


# load master abridged

setwd("~/Code/NJ-opioidenv/data_final")
#setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master.all <- read.csv("master(no_index).csv")
master.all$SSN <- as.integer((as.character(master.all$SSN)))

master.geo <- st_read("master_geog.geojson")
masterSF <- subset(master.geo[,c("Place.Name","SSN","area")])
masterSF$SSN <- as.integer((as.character(masterSF$SSN)))
masterSF <- left_join(masterSF, master.all, by = "SSN")

masterSF$bizDens <- masterSF$bizNum / masterSF$area.x
masterSF$pubTransit2 <- masterSF$pubTransit / masterSF$pop2016
masterSF$noVehicle2 <- masterSF$noVehicle / masterSF$pop2016
masterSF$avgVacBiz <- masterSF$avgVacBiz / masterSF$bizNum



master.all <- masterSF

### Make groups

##Quality of the comercial environment:

sub1 <- c("SSN", "alcLicKm2", "noVehicle2", "pubTransit2", "avgVacBiz", "bizDens")

m_ce <- master.all[sub1]

m_ce[is.na(m_ce)] <- 0


#correct for direction and scale

m_ce$transportation <- (m_ce$noVehicle2 + m_ce$pubTransit2) / 2

avgVacBiz <- tm_shape(m_ce) + tm_polygons("avgVacBiz" , pal= "BuPu", style = "quantile", n = 4)
bizDens <- tm_shape(m_ce) + tm_polygons("bizDens", pal= "BuPu", style = "quantile", n = 4)
alcLicKm2 <- tm_shape(m_ce) + tm_polygons("alcLicKm2", pal= "BuPu", style = "quantile", n = 4)
noVehicle2 <- tm_shape(m_ce) + tm_polygons("noVehicle2", pal= "BuPu", style = "quantile", n = 4)
pubTransit2 <- tm_shape(m_ce) + tm_polygons("pubTransit2", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(avgVacBiz, bizDens, alcLicKm2, noVehicle2, pubTransit2)


m_ce$avgVacBizS <- rescale(m_ce$avgVacBiz, to = c(0,100)) #higher = worse
m_ce$bizDensS <- rescale(m_ce$bizDens, to = c(100,0))
m_ce$alcLicKm2S <- rescale(m_ce$alcLicKm2,to = c(0,100)) #higher = worse
m_ce$noVehicleS <- rescale(m_ce$noVehicle2, to = c(0,100)) #higher = worse
m_ce$pubTransitS <- rescale(m_ce$pubTransit2, to = c(100,0))
m_ce$transportationS <- (m_ce$noVehicleS + m_ce$pubTransitS) / 2

avgVacBiz <- tm_shape(m_ce) + tm_polygons("avgVacBizS", pal= "BuPu", style = "quantile", n = 4)
bizDens <- tm_shape(m_ce) + tm_polygons("bizDensS", pal= "BuPu", style = "quantile", n = 4)
alcLicKm2 <- tm_shape(m_ce) + tm_polygons("alcLicKm2S", pal= "BuPu", style = "quantile", n = 4)
transportation <- tm_shape(m_ce) + tm_polygons("transportationS", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(avgVacBiz, bizDens, alcLicKm2, transportation)

noVehicleS <- tm_shape(m_ce) + tm_polygons("noVehicleS", pal= "BuPu", style = "quantile", n = 4)
pubTransit2S <- tm_shape(m_ce) + tm_polygons("pubTransitS", pal= "BuPu", style = "quantile", n = 4)
transportation <- tm_shape(m_ce) + tm_polygons("transportationS", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(noVehicleS, pubTransit2S, transportation)


#m_ce$bus_vac <- -scale(m_ce$bus_vac)
#m_ce$avg_vac_b <- -scale(m_ce$avg_vac_b)
#m_ce$ams_bus <- scale(m_ce$ams_bus)
#m_ce$ls_per_sqft <- -scale(m_ce$ls_per_sqft)
#m_ce$no_vehicle <- -scale(m_ce$no_vehicle)
#m_ce$public_transit <- scale(m_ce$public_transit)

m_ce$commEnv <- (m_ce$avgVacBizS +  m_ce$bizDensS + m_ce$alcLicKm2S + m_ce$transportationS) / 4


tm_shape(m_ce) + tm_polygons("commEnv", pal= "BuPu", style = "quantile", n = 4)

## Quality of the Residential Environment

sub2 <- c("schoolPPop", "multiunit", "occRate", "mblHomePct", "mblHome", "avgPropTax", 
          "house20Yr", "rentPct", "medRent", "medHValue", 
          "burdenPct", "crowdedPct", "frClsRtMrt")


m_re <- master.all[sub2]

m_re[is.na(m_re)] <- 0

#correct for direction and scale

m_re$multiunit <- rescale(m_re$multiunit, to = c(100,0))
m_re$mblHomePct <- rescale(m_re$mblHomePct, to = c(100,0))
m_re$crowdedPct <- rescale(m_re$crowdedPct, to = c(100,0))
m_re$rentPct <- rescale(m_re$rentPct, to = c(100,0))
m_re$housingstock <- (m_re$multiunit + m_re$mblHomePct + m_re$mblHome
                      + m_re$crowdedPct + m_re$rentPct) / 5



m_re$house20Yr <- rescale(m_re$house20Yr, to = c(0, 100))
m_re$occRate <- rescale(m_re$occRate, to = c(0, 100))
m_re$stability <- (m_re$house20Yr + m_re$occRate) / 2

m_re$medRent <- rescale(m_re$medRent, to = c(100,0))
m_re$burdenPct <- rescale(m_re$burdenPct, to = c(100,0))
m_re$medHValue <- rescale(m_re$medHValue, to = c(0, 100))
m_re$avgPropTax <- rescale(m_re$avgPropTax, to = c(0, 100))
m_re$affordability <- (m_re$medRent + m_re$burdenPct
                       + m_re$medHValue + m_re$avgPropTax) / 4


m_re$frClsRtMrt <- rescale(m_re$frClsRtMrt, to = c(100,0))


m_re$resEnv <- (m_re$housingstock + m_re$stability + m_re$affordability
               + m_re$frClsRtMrt) / 4

tm_shape(m_re) + tm_polygons("resEnv", pal= "BuPu", style = "quantile", n = 4)


## Physical Environment

sub3 <- c("HDensRes", "indUrb", "parksProp", "allPaths", 
          "ndvi", "resPctTot", "comPctTot", "indPctTot")

m_pe <- master.all[sub3]

m_pe$HDensRes = rescale(m_pe$HDensRes, to = c(100,0))
m_pe$resPctTot = rescale(m_pe$resPctTot, to = c(100,0))
m_pe$comPctTot = rescale(m_pe$comPctTot, to = c(0, 100))
m_pe$indUrb = rescale(m_pe$indUrb, to = c(100, 0))
m_pe$indPctTot = rescale(m_pe$indPctTot, to = c(100, 0))
m_pe$zoning <- (m_pe$HDensRes + m_pe$resPctTot + m_pe$comPctTot 
                + m_pe$indUrb + m_pe$indPctTot) / 5

m_pe$allPaths = rescale(m_pe$allPaths, to = c(0,100))

m_pe$parksProp = rescale(m_pe$parksProp, to = c(0,100))

m_pe$ndvi = rescale(m_pe$ndvi, to = c(0,100))

m_pe$phyEnv = (m_pe$zoning + m_pe$allPaths + m_pe$parksProp + m_pe$ndvi) / 4


tm_shape(m_pe) + tm_polygons("phyEnv", pal= "BuPu", style = "quantile", n = 4)

######################################
## Health Service ####################
######################################

sub4 <- c( "syrngDist", "naloxDist", "moudDist", "sutDist")
  
  
m_he <- master.all[sub4]

nalox <- tm_shape(m_he) + tm_polygons("naloxDist", pal= "BuPu", style = "jenks", n = 4)
moud <- tm_shape(m_he) + tm_polygons("moudDist", pal= "BuPu", style = "jenks", n = 4)
synr <- tm_shape(m_he) + tm_polygons("syrngDist", pal= "BuPu", style = "jenks", n = 4)
sut <- tm_shape(m_he) + tm_polygons("sutDist", pal= "BuPu", style = "jenks", n = 4)
tmap_arrange(nalox, moud, synr, sut)


m_he$naloxS <- rescale(m_he$naloxDist, to = c(0,100)) #higher = worse
m_he$moudS <- rescale(m_he$moudDist, to = c(0,100))
m_he$syrngS <-  rescale(m_he$syrngDist, to = c(0,100))
m_he$sutS <- rescale(m_he$sutDist, to = c(0,100))

nalox <- tm_shape(m_he) + tm_polygons("naloxS", pal= "BuPu", style = "jenks", n = 4)
moud <- tm_shape(m_he) + tm_polygons("moudS", pal= "BuPu", style = "jenks", n = 4)
synr <- tm_shape(m_he) + tm_polygons("syrngS", pal= "BuPu", style = "jenks", n = 4)
sut <- tm_shape(m_he) + tm_polygons("sutS", pal= "BuPu", style = "jenks", n = 4)
tmap_arrange(nalox, moud, synr, sut)

m_he$hsaEnv = (m_he$naloxS + m_he$moudS + m_he$syrngS + m_he$sutS) / 4

tm_shape(m_he) + tm_polygons("hsaEnv", pal= "BuPu", style = "quantile", n = 4)

######################################
## community particpation ############
######################################

sub5 <- c("SSN", "adultEdDst", "cultrDist", "voluntrOp")

m_co <- master.all[sub5]

adultEdDst <- tm_shape(m_co) + tm_polygons("adultEdDst", pal= "BuPu", style = "jenks", n = 4)
cultrDist <- tm_shape(m_co) + tm_polygons("cultrDist", pal= "BuPu", style = "jenks", n = 4)
voluntrOp <- tm_shape(m_co) + tm_polygons("voluntrOp", pal= "BuPu", style = "jenks", n = 4)
tmap_arrange (adultEdDst, cultrDist, voluntrOp)


m_co$voluntrOpS <- rescale(m_co$voluntrOp, to = c(100,0))
m_co$adultEdDstS <- rescale(m_co$adultEdDst, to = c(0,100))
m_co$cultrDistS <- rescale(m_co$cultrDist, to = c(0,100))

adultEdDst <- tm_shape(m_co) + tm_polygons("adultEdDstS", pal= "BuPu", style = "jenks", n = 4)
cultrDist <- tm_shape(m_co) + tm_polygons("cultrDistS", pal= "BuPu", style = "jenks", n = 4)
voluntrOp <- tm_shape(m_co) + tm_polygons("voluntrOpS", pal= "BuPu", style = "jenks", n = 4)
tmap_arrange (adultEdDst, cultrDist, voluntrOp)

m_co$compEnv <- (m_co$voluntrOp + m_co$adultEdDst + m_co$cultrDist) / 3

tm_shape(m_co) + tm_polygons("compEnv", pal= "BuPu", style = "quantile", n = 4)

######################################
## strength of community economy
######################################

sub6 <- c("SSN", "empPerCap", "incPerCap", "snapP", "govExp")

m_econ <- master.all[sub6]

empPerCap <- tm_shape(m_econ) + tm_polygons("empPerCap", pal= "BuPu", style = "jenks", n = 4)
incPerCap <- tm_shape(m_econ) + tm_polygons("incPerCap", pal= "BuPu", style = "jenks", n = 4)
snapP <- tm_shape(m_econ) + tm_polygons("snapP", pal= "BuPu", style = "jenks", n = 4)
govExp <- tm_shape(m_econ) + tm_polygons("govExp", pal= "BuPu", style = "jenks", n = 4)
tmap_arrange (empPerCap, incPerCap, snapP,govExp)

m_econ$incPerCapS <- rescale(m_econ$incPerCap, to = c(100,0))
m_econ$empPerCapS <- rescale(m_econ$empPerCap, to = c(100,0))
m_econ$snapPS <- rescale(m_econ$snapP, to = c(0,100))
m_econ$govExpS <- rescale(m_econ$govExp, to = c(100,0))

empPerCap <- tm_shape(m_econ) + tm_polygons("empPerCapS", pal= "BuPu", style = "jenks", n = 4)
incPerCap <- tm_shape(m_econ) + tm_polygons("incPerCapS", pal= "BuPu", style = "jenks", n = 4)
snapP <- tm_shape(m_econ) + tm_polygons("snapPS", pal= "BuPu", style = "jenks", n = 4)
govExp <- tm_shape(m_econ) + tm_polygons("govExpS", pal= "BuPu", style = "jenks", n = 4)
tmap_arrange (empPerCap, incPerCap, snapP,govExp)

m_econ$comeEnv <- (m_econ$incPerCapS + m_econ$empPerCapS
                 + m_econ$snapPS + m_econ$govExpS) / 4


tm_shape(m_econ) + tm_polygons("comeEnv", pal= "BuPu", style = "quantile", n = 4)





## master

masterSF$commEnv <- m_ce$commEnv
masterSF$compEnv <- m_co$compEnv
masterSF$comeEnv <- m_econ$comeEnv
masterSF$hsaEnv <- m_he$hsaEnv
masterSF$phyEnv <- m_pe$phyEnv
masterSF$resEnv <- m_re$resEnv


masterSF$BEIndex <- (masterSF$commEnv + masterSF$compEnv + masterSF$comeEnv + masterSF$hsaEnv +
                           masterSF$phyEnv + masterSF$resEnv) / 6

tm_shape(masterSF) + tm_polygons("BEIndex", pal= "BuPu", style = "quantile", n = 4)


master_index <- rename(master_index, SSN = `master.all$SSN`)


master_index$commEnv <- m_ce$commEnv
master_index$compEnv <- m_co$compEnv
master_index$comeEnv <- m_econ$comeEnv
master_index$hsaEnv <- m_he$hsaEnv
master_index$phyEnv <- m_pe$phyEnv
master_index$resEnv <- m_re$resEnv


##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_index, "conceptual_index.csv", row.names = FALSE) 


##### merge to master


### Merge to masters
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("final_master.csv")

master_updated <- left_join(master, master_index, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "master_final.csv", row.names = FALSE) 






