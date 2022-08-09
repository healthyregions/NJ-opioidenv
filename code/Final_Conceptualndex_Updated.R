library(scales)
library(sf)
library(tmap)
library(dplyr)


setwd("~/Code/NJ-opioidenv/data_final")

NJmaster <- read_sf("NJMaster_finaindexl.geojson")

names(NJmaster)

str(NJmaster$govExp)
  
######################################
## Recalc strength of community economy
######################################

sub6 <- c("SSN", "empPerCap", "incPerCap", "snapP", "govExp")

m_econ <- master.all[sub6]

empPerCap <- tm_shape(m_econ) + tm_fill("empPerCap", pal= "BuPu", style = "quantile", n = 4)
incPerCap <- tm_shape(m_econ) + tm_fill("incPerCap", pal= "BuPu", style = "quantile", n = 4)
snapP <- tm_shape(m_econ) + tm_fill("snapP", pal= "BuPu", style = "quantile", n = 4)
govExp <- tm_shape(m_econ) + tm_fill("govExp", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange (empPerCap, incPerCap, snapP,govExp)

m_econ$incPerCapS <- rescale(m_econ$incPerCap, to = c(100,0))
m_econ$empPerCapS <- rescale(m_econ$empPerCap, to = c(100,0))
m_econ$snapPS <- rescale(m_econ$snapP, to = c(0,100))
m_econ$govExpS <- rescale(m_econ$govExp, to = c(100,0))

empPerCap <- tm_shape(m_econ) + tm_fill("empPerCapS", pal= "BuPu", style = "quantile", n = 4)
incPerCap <- tm_shape(m_econ) + tm_fill("incPerCapS", pal= "BuPu", style = "quantile", n = 4)
snapP <- tm_shape(m_econ) + tm_fill("snapPS", pal= "BuPu", style = "quantile", n = 4)
govExp <- tm_shape(m_econ) + tm_fill("govExpS", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange (empPerCap, incPerCap, snapP,govExp)

m_econ$comEnv <- (m_econ$incPerCapS + m_econ$empPerCapS + m_econ$snapPS + m_econ$govExpS) / 4


tm_shape(m_econ) + tm_fill("comEnv", pal= "BuPu", style = "quantile", n = 4)



## master

master.all$commEnv <- m_ce$commEnv
master.all$compEnv <- m_co$compEnv
master.all$comEnv <- m_econ$comEnv
master.all$hsaEnv <- m_he$hsaEnv
master.all$phyEnv <- m_pe$phyEnv
master.all$resEnv <- m_re$resEnv

write_sf(final, "NJMaster_finalindex2.geojson")

master <- st_drop_geometry(final)
write.csv(master,"NJMaster_finalindex2.csv")


master.all$BEIndex <- (master.all$commEnv + master.all$compEnv + master.all$comEnv + master.all$hsaEnv +
                         master.all$phyEnv + master.all$resEnv) / 6

tm_shape(master.all) + tm_fill("BEIndex", pal= "BuPu", style = "quantile", n = 4)

commEnv <- tm_shape(master.all) + tm_fill("commEnv", pal= "BuPu", style = "quantile", n = 4)
compEnv <- tm_shape(master.all) + tm_fill("compEnv", pal= "BuPu", style = "quantile", n = 4)
comeEnv <- tm_shape(master.all) + tm_fill("comEnv", pal= "BuPu", style = "quantile", n = 4)
hsaEnv <- tm_shape(master.all) + tm_fill("hsaEnv", pal= "BuPu", style = "quantile", n = 4)
phyEnv <- tm_shape(master.all) + tm_fill("phyEnv", pal= "BuPu", style = "quantile", n = 4)
resEnv <- tm_shape(master.all) + tm_fill("resEnv", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange (commEnv, compEnv, comeEnv,hsaEnv,phyEnv,resEnv)

names(master.all)

write_sf(master.all, "NJMaster_finalindex.geojson")

master <- st_drop_geometry(master.all)
write.csv(master,"NJMaster_finalindex.csv")


opDtRt16 <- tm_shape(master.all) + tm_fill("opDtRt16", pal= "BuPu", style = "quantile", n = 4)
opDtRt17 <- tm_shape(master.all) + tm_fill("opDtRt17", pal= "BuPu", style = "quantile", n = 4)
opDtRt18 <- tm_shape(master.all) + tm_fill("opDtRt18", pal= "BuPu", style = "quantile", n = 4)
opDtRt15 <- tm_shape(master.all) + tm_fill("opDtRt15", pal= "BuPu", style = "quantile", n = 4)
opDtRt1518ave <- tm_shape(master.all) + tm_fill("phyEnv", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange (opDtRt15, opDtRt16, opDtRt17, opDtRt18,opDtRt1518ave)



final <- read_sf("NJMaster_finalindex.geojson")

final$commEnv2 <- rescale(final$commEnv, to = c(0,100))
final$compEnv2 <- rescale(final$compEnv, to = c(0,100))
final$comEnv2 <- rescale(final$comEnv, to = c(0,100))
final$hsaEnv2 <- rescale(final$hsaEnv, to = c(0,100))
final$phyEnv2 <- rescale(final$phyEnv, to = c(0,100))
final$resEnv2 <- rescale(final$resEnv, to = c(0,100))

final$BEIndex2 <- (final$commEnv2 + final$compEnv2 + final$comEnv2 + final$hsaEnv2 +
                     final$phyEnv2 + final$resEnv2) / 6

tm_shape(final) + tm_fill("BEIndex2", pal= "BuPu", style = "quantile", n = 4)


final$BEIndexs <- rescale(final$BEIndex, to = c(0,100))
tm_shape(final) + tm_fill("BEIndexs", pal= "BuPu", style = "jenks", n = 4)

BEIndex <- tm_shape(final) + tm_fill("BEIndex", pal= "BuPu", style = "quantile", n = 4)
BEIndex2 <- tm_shape(final) + tm_fill("BEIndex2", pal= "BuPu", style = "quantile", n = 4)
BEIndexs <- tm_shape(final) + tm_fill("BEIndexs", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange (BEIndex, BEIndex2, BEIndexs)

