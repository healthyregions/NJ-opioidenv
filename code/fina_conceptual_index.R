#INDEX

#install.packages("scales")

library(scales)
library(sf)
library(tmap)
library(dplyr)


# load master abridged

#setwd("~/Code/NJ-opioidenv/data_final")
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master.all <- read.csv("master(no_index).csv")
master.all$SSN <- as.integer((as.character(master.all$SSN)))

master.geo <- st_read("master_geog.geojson")
masterSF <- subset(master.geo[,c("Place.Name","SSN","area")])
masterSF$SSN <- as.integer((as.character(masterSF$SSN)))
masterSF <- left_join(masterSF, master.all, by = "SSN")

masterSF$bizDens <- masterSF$bizNum / masterSF$area.x

master.all <- masterSF

### Make groups

##Quality of the comercial environment:

sub1 <- c("SSN", "alcLicKm2", "noVehicle", "pubTransit", "avgVacBiz", "bizNum")

m_ce <- master.all[sub1]

m_ce[is.na(m_ce)] <- 0


#correct for direction and scale

m_ce$avgVacBiz <- rescale(m_ce$avgVacBiz, to = c(100,0))
m_ce$bizNum <- rescale(m_ce$bizNum, to = c(0, 100))
m_ce$alcLicKm2 <- rescale(m_ce$alcLicKm2,to = c(100,0))

m_ce$noVehicle <- rescale(m_ce$noVehicle, to = c(100,0))
m_ce$pubTransit <- rescale(m_ce$pubTransit, to = c(0, 100))
m_ce$transportation <- (m_ce$noVehicle + m_ce$pubTransit) / 2

#m_ce$bus_vac <- -scale(m_ce$bus_vac)
#m_ce$avg_vac_b <- -scale(m_ce$avg_vac_b)
#m_ce$ams_bus <- scale(m_ce$ams_bus)
#m_ce$ls_per_sqft <- -scale(m_ce$ls_per_sqft)
#m_ce$no_vehicle <- -scale(m_ce$no_vehicle)
#m_ce$public_transit <- scale(m_ce$public_transit)



m_ce$commEnv <- (m_ce$avgVacBiz +  m_ce$bizNum + m_ce$alcLicKm2 + m_ce$transportation) / 4

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
m_re$mblHome <- rescale(m_re$mblHome, to = c(100,0))
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


## Health Service

sub4 <- c( "naloxProp", "syrngProp", "moudProp", "sutProp")
  
  
m_he <- master.all[sub4]

m_he$naloxProp = rescale(m_he$naloxProp, to = c(100,0))
m_he$moudProp = rescale(m_he$moudProp, to = c(100,0))
m_he$moud <- (m_he$naloxProp + m_he$moudProp) / 2

m_he$syrngProp = rescale(m_he$syrngProp, to = c(100,0))

m_he$sutProp = rescale(m_he$sutProp, to = c(100,0))



m_he$hsaEnv = (m_he$moud + m_he$syrngProp + m_he$sutProp) / 3


## community particpation

sub5 <- c("SSN", "adultEdDst", "cultrDist", "voluntrOp")

m_co <- master.all[sub5]


m_co$voluntrOp <- rescale(m_co$voluntrOp, to = c(0,100))
m_co$adultEdDst <- rescale(m_co$adultEdDst, to = c(100,0))
m_co$cultrDist <- rescale(m_co$cultrDist, to = c(100,0))


m_co$compEnv <- (m_co$voluntrOp + m_co$adultEdDst + m_co$cultrDist) / 3


## strength of community economy

sub6 <- c("SSN", "empPerCap", "incPerCap", "snapP", "govExp")

m_econ <- master.all[sub6]


m_econ$incPerCap <- rescale(m_econ$incPerCap, to = c(0,100))
m_econ$empPerCap <- rescale(m_econ$empPerCap, to = c(0,100))
m_econ$snapP <- rescale(m_econ$snapP, to = c(100,0))
m_econ$govExp <- rescale(m_econ$govExp, to = c(0,100))

m_econ$comeEnv <- (m_econ$incPerCap + m_econ$empPerCap
                 + m_econ$snapP + m_econ$govExp) / 4







## master
master_index <- as.data.frame(master.all$SSN)

master_index$BEIndex <- (m_ce$commEnv + m_co$compEnv + m_econ$comeEnv + m_he$hsaEnv +
                         m_pe$phyEnv + m_re$resEnv) / 6

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






