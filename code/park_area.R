### Read in parks
setwd("~/Documents/HEROP")
parks_all <- read.csv("~/Documents/HEROP/State%2C_Local_and_Nonprofit_Open_Space_of_New_Jersey.csv")


## subset

sub <- c("MUNICIPALITY", "PCL_MUN", "GISACRES", "SHAPE_Area")
parksub <- parks_all[sub]



## aggregate GIS acres column (confirmed, acres)

GISagg <- aggregate(parksub$GISACRES, by=list(PCL_MUN=parksub$PCL_MUN), FUN=sum)
GISagg <- rename(GISagg, total_area = x)


## aggregate area size column (confirmed, square feet)

areaagg <- aggregate(parksub$SHAPE_Area, by=list(PCL_MUN=parksub$PCL_MUN), FUN=sum)
areaagg <- rename(areaagg, total_area = x)
areaagg <- rename(areaagg, SSN = PCL_MUN)



# load in municipal shapefile

## New Jersey Municipalities
setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
nj_municipal <- read_sf("Municipal_Boundaries_of_NJ.shp")
nj_municipal$SSN <- as.numeric(nj_municipal$SSN)

njsub <- c("MUN", "SSN", "Shape_Area")

munsub <- nj_municipal[njsub]

## confirmed sq feet for NJ mun

parksmerge <- left_join(munsub, areaagg, by = "SSN")


parksmerge$parksProp <- parksmerge$total_area / parksmerge$Shape_Area
parksmerge$parksProp[is.na(parksmerge$parksProp)] <- 0

ParkArea <- parksmerge[c("MUN", "SSN", "parksProp")]
ParkArea$geometry = NULL

### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(ParkArea, "ParkArea.csv", row.names = FALSE)


#save to master

### Merge to masters
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("working_master(abridged).csv")

ParkArea$MUN = NULL

master_updated <- merge(master, ParkArea, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "working_master(abridged).csv", row.names = FALSE) 




