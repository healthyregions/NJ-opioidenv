# Data Cleaning 


library(scales)
library(sf)
library(tmap)
library(dplyr)


NJmaster <- read_sf("NJMaster_finalindex.geojson")
names(NJmaster)

NJmaster$govExp <- as.numeric(NJmaster$govExp)
str(NJmaster$govExp)

######################################
## strength of community economy
######################################

sub6 <- c("SSN", "empPerCap", "incPerCap", "snapP", "govExp")


m_econ <- NJmaster[sub6]
head(m_econ)

empPerCap <- tm_shape(m_econ) + tm_fill("empPerCap", pal= "BuPu", style = "quantile", n = 4)
incPerCap <- tm_shape(m_econ) + tm_fill("incPerCap", pal= "BuPu", style = "quantile", n = 4)
snapP <- tm_shape(m_econ) + tm_fill("snapP", pal= "BuPu", style = "quantile", n = 4)
govExp <- tm_shape(m_econ) + tm_fill("govExp", pal= "BuPu", style = "quantile", n = 4)
tmap_arrange (empPerCap, incPerCap, snapP,govExp)

m_econ$incPerCapS <- rescale(m_econ$incPerCap, to = c(100,0))
m_econ$empPerCapS <- rescale(m_econ$empPerCap, to = c(100,0))
m_econ$snapPS <- rescale(m_econ$snapP, to = c(0,100))
m_econ$govExpS <- rescale(m_econ$govExp, to = c(100,0))


write_sf(m_econ, "test1.geojson")
# Fixed missing value in GeoDa


m_econ <- read_sf("test1.geojson")

tm_shape(m_econ) + tm_fill("comEnv", pal= "BuPu", style = "quantile", n = 4)


## Merge back to main file 

Final <- read_sf("NJMaster_finalindex3.geojson")

head(m_econ)

sub7 <- c("SSN", "comEnv")
m_econ <- m_econ[sub7]
m_econ <- st_drop_geometry(m_econ)

head(Final)
head(m_econ)
Final <- merge(Final, m_econ, by="SSN")

tm_shape(Final) + tm_fill("comEnv.y", pal= "BuPu", style = "quantile", n = 4)


master.all<- Final
master.all$BEIndex <- (master.all$commEnv + master.all$compEnv + master.all$comEnv.y + master.all$hsaEnv +
                         master.all$phyEnv + master.all$resEnv) / 6

tm_shape(master.all) + tm_fill("BEIndex", pal= "BuPu", style = "quantile", n = 4)

write_sf(master.all, "NJMaster_finalindex22.geojson")

write.csv(st_drop_geometry(master.all), "NJMaster_finalindex22.csv")
