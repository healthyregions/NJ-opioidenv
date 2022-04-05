



library(scales)
library(sf)
library(tmap)
library(dplyr)


setwd("~/Code/NJ-opioidenv/data_final")

NJmaster <- read_sf("NJMaster.geojson")

names(NJmaster)
  
#####################

# Calculate Indices

#####################

# masterNew <- subset(masterSF[,c("SSN", "municipality", "pop2017", "areaMi",
#                                "alcLicMi", "noVhcleRt", "pubTransRt","avgVacBiz", "bizDens",
#                                "syrngDist", "naloxDist", "moudDist", "sutDist", "mentHlDist",
#                                "HDensRes", "parksProp", "allPaths", "ndvi", "resPctTot", 
#                                "comPctTot", "indPctTot",
#                                "schoolPPop", "multiUnRt", "occRate", "mblHomePct", 
#                                "avgPropTax", "hs20yrRt", "rentPct", "medRent", 
#                                "medHValue", "burdenPct", "crowdedPct", "frClsRtMrt",
#                                "empPerCap", "incPerCap", "snapP", "govExp",
#                                "adultEdDst", "cultrDist", "voluntrOp",
#                                "isoAsian", "isoBlack", "isoHisp", "SVIthemes",
#                                "mriScore", "landUseClass", "popDens17", 
#                                "hsGradRt", "vlntCrRt",
#                                "opDtRt15", "opDtRt16", "opDtRt17", "opDtRt18", "opDtRt1518ave",
#                                "opDt15", "opDt16","opDt17", "opDt18", "opDt1518sum")])


### Make groups

#######################################
##Quality of the comercial environment:
#######################################

sub1 <- c("SSN", "alcLicMi", "noVhcleRt", "pubTransRt","avgVacBiz", "bizDens")


master.all <- NJmaster
m_ce <- master.all[sub1]

m_ce[is.na(m_ce)] <- 0


#correct for direction and scale

m_ce$transportation <- (m_ce$noVhcleRt + m_ce$pubTransRt) / 2

avgVacBiz <- tm_shape(m_ce) + tm_fill("avgVacBiz" , pal= "BuPu", style = "quantile", n = 4)
bizDens <- tm_shape(m_ce) + tm_fill("bizDens", pal= "BuPu", style = "quantile", n = 4)
alcLicKm2 <- tm_shape(m_ce) + tm_fill("alcLicMi", pal= "BuPu", style = "quantile", n = 4)
noVehicle2 <- tm_shape(m_ce) + tm_fill("noVhcleRt", pal= "BuPu", style = "quantile", n = 4)
pubTransit2 <- tm_shape(m_ce) + tm_fill("pubTransRt", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(avgVacBiz, bizDens, alcLicKm2, noVehicle2, pubTransit2)


m_ce$avgVacBizS <- rescale(m_ce$avgVacBiz, to = c(0,100)) #higher = worse
m_ce$bizDensS <- rescale(m_ce$bizDens, to = c(100,0))
m_ce$alcLicKm2S <- rescale(m_ce$alcLicMi,to = c(0,100)) #higher = worse
m_ce$noVehicleS <- rescale(m_ce$noVhcleRt, to = c(0,100)) #higher = worse
m_ce$pubTransitS <- rescale(m_ce$pubTransRt, to = c(100,0))
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


m_ce$commEnv <- (m_ce$avgVacBizS +  m_ce$bizDensS + m_ce$alcLicKm2S + m_ce$transportationS) / 4
tm_shape(m_ce) + tm_polygons("commEnv", pal= "BuPu", style = "quantile", n = 4)

###########################################
## Quality of the Residential Environment
###########################################

sub2 <- c("schoolPPop", "multiUnRt", "occRate", "mblHomePct",
          "avgPropTax", "hs20yrRt", "rentPct", "medRent",
          "medHValue", "burdenPct", "crowdedPct", "frClsRtMrt")

m_re <- master.all[sub2]

m_re[is.na(m_re)] <- 0

#correct for direction and scale

multiunit <- tm_shape(m_re) + tm_polygons("multiUnRt" , pal= "BuPu", style = "quantile", n = 4)
mblHomePct <- tm_shape(m_re) + tm_polygons("mblHomePct", pal= "BuPu", style = "quantile", n = 4)
crowdedPct <- tm_shape(m_re) + tm_polygons("crowdedPct", pal= "BuPu", style = "quantile", n = 4)
rentPct <- tm_shape(m_re) + tm_polygons("rentPct", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(multiunit, mblHomePct, crowdedPct, rentPct)

m_re$multiunitS <- rescale(m_re$multiUnRt, to = c(0,100)) #higher = worse
m_re$mblHomePctS <- rescale(m_re$mblHomePct, to = c(0,100)) #higher = worse
m_re$crowdedPctS <- rescale(m_re$crowdedPct, to = c(0,100)) #higher = worse
m_re$rentPctS <- rescale(m_re$rentPct, to = c(0,100)) #higher = worse
m_re$housingstock <- (m_re$multiUnRtS + m_re$mblHomePctS +
                        m_re$crowdedPctS + m_re$rentPctS) / 4

multiunit <- tm_shape(m_re) + tm_polygons("multiUnRtS" , pal= "BuPu", style = "quantile", n = 4)
mblHomePct <- tm_shape(m_re) + tm_polygons("mblHomePctS", pal= "BuPu", style = "quantile", n = 4)
crowdedPct <- tm_shape(m_re) + tm_polygons("crowdedPctS", pal= "BuPu", style = "quantile", n = 4)
rentPct <- tm_shape(m_re) + tm_polygons("rentPctS", pal= "BuPu", style = "quantile", n = 4)
housingstock <- tm_shape(m_re) + tm_polygons("housingstock", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(multiunit, mblHomePct, crowdedPct, rentPct, housingstock)

#############3

house20Yr <- tm_shape(m_re) + tm_polygons("house20Yr" , pal= "BuPu", style = "quantile", n = 4)
occRate <- tm_shape(m_re) + tm_polygons("occRate", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(house20Yr, occRate)

m_re$house20YrS <- rescale(m_re$house20Yr, to = c(100,0)) #higher = better
m_re$occRateS <- rescale(m_re$occRate, to = c(100,0)) #higher = better
m_re$stabilityS <- (m_re$house20YrS + m_re$occRateS) / 2

house20Yr <- tm_shape(m_re) + tm_polygons("house20YrS" , pal= "BuPu", style = "quantile", n = 4)
occRate <- tm_shape(m_re) + tm_polygons("occRateS", pal= "BuPu", style = "quantile", n = 4)
stabilityS <- tm_shape(m_re) + tm_polygons("stabilityS", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(house20Yr, occRate, stabilityS)


##############

medRent <- tm_shape(m_re) + tm_polygons("medRent" , pal= "BuPu", style = "quantile", n = 4)
burdenPct <- tm_shape(m_re) + tm_polygons("burdenPct", pal= "BuPu", style = "quantile", n = 4)
medHValue <- tm_shape(m_re) + tm_polygons("medHValue" , pal= "BuPu", style = "quantile", n = 4)
avgPropTax <- tm_shape(m_re) + tm_polygons("avgPropTax", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(medRent, burdenPct, medHValue, avgPropTax)

m_re$medRentS <- rescale(m_re$medRent, to =  c(0,100)) #higher = worse
m_re$burdenPctS <- rescale(m_re$burdenPct, to =  c(0,100)) #higher = worse
m_re$medHValueS <- rescale(m_re$medHValue, to =  c(0,100)) #higher = worse
m_re$avgPropTaxS <- rescale(m_re$avgPropTax, to =  c(0,100)) #higher = worse
m_re$affordability <- (m_re$medRentS + m_re$burdenPctS
                       + m_re$medHValueS + m_re$avgPropTaxS) / 4

medRent <- tm_shape(m_re) + tm_polygons("medRentS" , pal= "BuPu", style = "quantile", n = 4)
burdenPct <- tm_shape(m_re) + tm_polygons("burdenPctS", pal= "BuPu", style = "quantile", n = 4)
medHValue <- tm_shape(m_re) + tm_polygons("medHValueS" , pal= "BuPu", style = "quantile", n = 4)
avgPropTax <- tm_shape(m_re) + tm_polygons("avgPropTaxS", pal= "BuPu", style = "quantile", n = 4)
affordability <- tm_shape(m_re) + tm_polygons("affordability", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(medRent, burdenPct, medHValue, avgPropTax, affordability)

##############

tm_shape(m_re) + tm_polygons("frClsRtMrt" , pal= "BuPu", style = "quantile", n = 4)
m_re$frClsRtMrtS <- rescale(m_re$frClsRtMrt, to = c(0,100)) #higher = worse

##############

housingstock <- tm_shape(m_re) + tm_polygons("housingstock" , pal= "BuPu", style = "quantile", n = 4)
stability <- tm_shape(m_re) + tm_polygons("stabilityS", pal= "BuPu", style = "quantile", n = 4)
affordability <- tm_shape(m_re) + tm_polygons("affordability" , pal= "BuPu", style = "quantile", n = 4)
frClsRtMrt <- tm_shape(m_re) + tm_polygons("frClsRtMrtS", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(housingstock, stability, affordability, frClsRtMrt)

m_re$resEnv <- (m_re$housingstock + m_re$stability + m_re$affordability
                + m_re$frClsRtMrtS) / 4

tm_shape(m_re) + tm_polygons("resEnv", pal= "BuPu", style = "quantile", n = 4)

######################
## Physical Environment
######################

sub3 <- c("HDensRes", "parksProp", "allPaths", "ndvi", 
          "resPctTot", "comPctTot", "indPctTot")

m_pe <- master.all[sub3]

HDensRes <- tm_shape(m_pe) + tm_polygons("HDensRes", pal= "BuPu", style = "quantile", n = 4)
resPctTot <- tm_shape(m_pe) + tm_polygons("resPctTot", pal= "BuPu", style = "quantile", n = 4)
comPctTot <- tm_shape(m_pe) + tm_polygons("comPctTot", pal= "BuPu", style = "quantile", n = 4)
indPctTot <- tm_shape(m_pe) + tm_polygons("indPctTot", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(HDensRes, resPctTot, comPctTot, indPctTot)

m_pe$HDensResS = rescale(m_pe$HDensRes, to = c(0,100)) #more dense, crowded/worse 
m_pe$resPctTotS = rescale(m_pe$resPctTot, to = c(100,0)) #higher, better
m_pe$comPctTotS = rescale(m_pe$comPctTot, to = c(100,0)) #higher, better
m_pe$indPctTotS = rescale(m_pe$indPctTot, to = c(0,100)) #higher = worse,
m_pe$zoning <- (m_pe$HDensResS + m_pe$resPctTotS + m_pe$comPctTotS + m_pe$indPctTotS) / 4

HDensRes <- tm_shape(m_pe) + tm_polygons("HDensResS", pal= "BuPu", style = "quantile", n = 4)
resPctTot <- tm_shape(m_pe) + tm_polygons("resPctTotS", pal= "BuPu", style = "quantile", n = 4)
comPctTot <- tm_shape(m_pe) + tm_polygons("comPctTotS", pal= "BuPu", style = "quantile", n = 4)
indPctTot <- tm_shape(m_pe) + tm_polygons("indPctTotS", pal= "BuPu", style = "quantile", n = 4)
zoning <- tm_shape(m_pe) + tm_polygons("zoning", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(HDensRes, resPctTot, comPctTot, indPctTot, zoning)

#######################

allPaths <- tm_shape(m_pe) + tm_polygons("allPaths", pal= "BuPu", style = "quantile", n = 4)
parksProp <- tm_shape(m_pe) + tm_polygons("parksProp", pal= "BuPu", style = "quantile", n = 4)
ndvi <- tm_shape(m_pe) + tm_polygons("ndvi", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(allPaths, parksProp, ndvi)

m_pe$allPathsS = rescale(m_pe$allPaths, to = c(100,0))#higher, better
m_pe$parksPropS = rescale(m_pe$parksProp, to = c(100,0))#higher, better
m_pe$ndviS = rescale(m_pe$ndvi, to = c(100,0))#higher, better

allPaths <- tm_shape(m_pe) + tm_polygons("allPathsS", pal= "BuPu", style = "quantile", n = 4)
parksProp <- tm_shape(m_pe) + tm_polygons("parksPropS", pal= "BuPu", style = "quantile", n = 4)
ndvi <- tm_shape(m_pe) + tm_polygons("ndviS", pal= "BuPu", style = "quantile", n = 4)
zoning <- tm_shape(m_pe) + tm_polygons("zoning", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(allPaths, parksProp, ndvi, zoning)

#######################

m_pe$phyEnv = (m_pe$zoning + m_pe$allPathsS + m_pe$parksPropS + m_pe$ndviS) / 4
tm_shape(m_pe) + tm_polygons("phyEnv", pal= "BuPu", style = "quantile", n = 4)

######################################
## Health Service ####################
######################################

sub4 <- c( "syrngDist", "naloxDist", "moudDist", "sutDist", "mentHlDist")


m_he <- master.all[sub4]

nalox <- tm_shape(m_he) + tm_polygons("naloxDist", pal= "BuPu", style = "quantile", n = 4)
moud <- tm_shape(m_he) + tm_polygons("moudDist", pal= "BuPu", style = "quantile", n = 4)
synr <- tm_shape(m_he) + tm_polygons("syrngDist", pal= "BuPu", style = "quantile", n = 4)
sut <- tm_shape(m_he) + tm_polygons("sutDist", pal= "BuPu", style = "quantile", n = 4)
mh <- tm_shape(m_he) + tm_polygons("mentHlDist", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(nalox, moud, synr, sut, mh)


m_he$naloxS <- rescale(m_he$naloxDist, to = c(0,100)) #higher = worse
m_he$moudS <- rescale(m_he$moudDist, to = c(0,100))
m_he$syrngS <-  rescale(m_he$syrngDist, to = c(0,100))
m_he$sutS <- rescale(m_he$sutDist, to = c(0,100))
m_he$mhS <- rescale(m_he$mentHlDist, to = c(0,100))


nalox <- tm_shape(m_he) + tm_polygons("naloxS", pal= "BuPu", style = "quantile", n = 4)
moud <- tm_shape(m_he) + tm_polygons("moudS", pal= "BuPu", style = "quantile", n = 4)
synr <- tm_shape(m_he) + tm_polygons("syrngS", pal= "BuPu", style = "quantile", n = 4)
sut <- tm_shape(m_he) + tm_polygons("sutS", pal= "BuPu", style = "quantile", n = 4)
mh <- tm_shape(m_he) + tm_polygons("mentHlDist", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange(nalox, moud, synr, sut, mh)

m_he$hsaEnv = (m_he$naloxS + m_he$moudS + m_he$syrngS + m_he$sutS + m_he$mhS) / 5

tm_shape(m_he) + tm_polygons("hsaEnv", pal= "BuPu", style = "quantile", n = 4)

######################################
## community particpation ############
######################################

sub5 <- c("SSN", "adultEdDst", "cultrDist", "voluntrOp")

m_co <- master.all[sub5]

adultEdDst <- tm_shape(m_co) + tm_polygons("adultEdDst", pal= "BuPu", style = "quantile", n = 4)
cultrDist <- tm_shape(m_co) + tm_polygons("cultrDist", pal= "BuPu", style = "quantile", n = 4)
voluntrOp <- tm_shape(m_co) + tm_polygons("voluntrOp", pal= "BuPu", style = "jenks", n = 4)
tmap_arrange (adultEdDst, cultrDist, voluntrOp)


m_co$voluntrOpS <- rescale(m_co$voluntrOp, to = c(100,0))
m_co$adultEdDstS <- rescale(m_co$adultEdDst, to = c(0,100))
m_co$cultrDistS <- rescale(m_co$cultrDist, to = c(0,100))

adultEdDst <- tm_shape(m_co) + tm_polygons("adultEdDstS", pal= "BuPu", style = "quantile", n = 4)
cultrDist <- tm_shape(m_co) + tm_polygons("cultrDistS", pal= "BuPu", style = "quantile", n = 4)
voluntrOp <- tm_shape(m_co) + tm_polygons("voluntrOpS", pal= "BuPu", style = "jenks", n = 4)
tmap_arrange (adultEdDst, cultrDist, voluntrOp)

m_co$compEnv <- (m_co$voluntrOpS + m_co$adultEdDstS + m_co$cultrDistS) / 3

tm_shape(m_co) + tm_polygons("compEnv", pal= "BuPu", style = "quantile", n = 4)

######################################
## strength of community economy
######################################

sub6 <- c("SSN", "empPerCap", "incPerCap", "snapP", "govExp")

m_econ <- master.all[sub6]

empPerCap <- tm_shape(m_econ) + tm_polygons("empPerCap", pal= "BuPu", style = "quantile", n = 4)
incPerCap <- tm_shape(m_econ) + tm_polygons("incPerCap", pal= "BuPu", style = "quantile", n = 4)
snapP <- tm_shape(m_econ) + tm_polygons("snapP", pal= "BuPu", style = "quantile", n = 4)
govExp <- tm_shape(m_econ) + tm_polygons("govExp", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange (empPerCap, incPerCap, snapP,govExp)

m_econ$incPerCapS <- rescale(m_econ$incPerCap, to = c(100,0))
m_econ$empPerCapS <- rescale(m_econ$empPerCap, to = c(100,0))
m_econ$snapPS <- rescale(m_econ$snapP, to = c(0,100))
m_econ$govExpS <- rescale(m_econ$govExp, to = c(100,0))

empPerCap <- tm_shape(m_econ) + tm_polygons("empPerCapS", pal= "BuPu", style = "quantile", n = 4)
incPerCap <- tm_shape(m_econ) + tm_polygons("incPerCapS", pal= "BuPu", style = "quantile", n = 4)
snapP <- tm_shape(m_econ) + tm_polygons("snapPS", pal= "BuPu", style = "quantile", n = 4)
govExp <- tm_shape(m_econ) + tm_polygons("govExpS", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange (empPerCap, incPerCap, snapP,govExp)

m_econ$comEnv <- (m_econ$incPerCapS + m_econ$empPerCapS + m_econ$snapPS + m_econ$govExpS) / 4


tm_shape(m_econ) + tm_polygons("comEnv", pal= "BuPu", style = "quantile", n = 4)



## master

masterSF$commEnv <- m_ce$commEnv
masterSF$compEnv <- m_co$compEnv
masterSF$comEnv <- m_econ$comEnv
masterSF$hsaEnv <- m_he$hsaEnv
masterSF$phyEnv <- m_pe$phyEnv
masterSF$resEnv <- m_re$resEnv



masterSF$BEIndex <- (masterSF$commEnv + masterSF$compEnv + masterSF$comEnv + masterSF$hsaEnv +
                       masterSF$phyEnv + masterSF$resEnv) / 6

tm_shape(masterSF) + tm_polygons("BEIndex", pal= "BuPu", style = "quantile", n = 4)

commEnv <- tm_shape(masterSF) + tm_polygons("commEnv", pal= "BuPu", style = "quantile", n = 4)
compEnv <- tm_shape(masterSF) + tm_polygons("compEnv", pal= "BuPu", style = "quantile", n = 4)
comeEnv <- tm_shape(masterSF) + tm_polygons("comEnv", pal= "BuPu", style = "quantile", n = 4)
hsaEnv <- tm_shape(masterSF) + tm_polygons("hsaEnv", pal= "BuPu", style = "quantile", n = 4)
phyEnv <- tm_shape(masterSF) + tm_polygons("phyEnv", pal= "BuPu", style = "quantile", n = 4)
resEnv <- tm_shape(masterSF) + tm_polygons("resEnv", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange (commEnv, compEnv, comeEnv,hsaEnv,phyEnv,resEnv)


