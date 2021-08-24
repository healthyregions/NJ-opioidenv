#INDEX

#install.packages("scales")

library(scales)
library(sf)
library(tmap)


# load master abridged

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master.all <- read.csv("master(abridged).csv")


### Make groups

##Quality of the comercial envoronment:

sub1 <- c("SSN", "bus_vac", "avg_vac_b", "ams_bus", "ls_per_sqft", "no_vehicle", "public_transit" )

m_ce <- master.all[sub1]

m_ce[is.na(m_ce)] <- 0

#correct for direction and scale

m_ce$bus_vac <- rescale(m_ce$bus_vac, to = c(100, 0))
m_ce$avg_vac_b <- rescale(m_ce$avg_vac_b, to = c(100,0))
m_ce$ams_bus <- rescale(m_ce$ams_bus, to = c(0, 100))
m_ce$ls_per_sqft <- rescale(m_ce$ls_per_sqft,to = c(100,0))
m_ce$no_vehicle <- rescale(m_ce$no_vehicle, to = c(100,0))
m_ce$public_transit <- rescale(m_ce$public_transit, to = c(0, 100))


#m_ce$bus_vac <- -scale(m_ce$bus_vac)
#m_ce$avg_vac_b <- -scale(m_ce$avg_vac_b)
#m_ce$ams_bus <- scale(m_ce$ams_bus)
#m_ce$ls_per_sqft <- -scale(m_ce$ls_per_sqft)
#m_ce$no_vehicle <- -scale(m_ce$no_vehicle)
#m_ce$public_transit <- scale(m_ce$public_transit)



m_ce$index <- (m_ce$bus_vac + m_ce$avg_vac_b + m_ce$ams_bus +
                 m_ce$ls_per_sqft + m_ce$no_vehicle + m_ce$public_transit) / 6


## Quality of the Residential Environment

sub2 <- c("SSN", "multiunit_struct", "mobile_home_rate", "percent_crowded", "percent_renter", 
          "num_households_20yrs","occupancy_rate", "median_rent", "percent_housing_cost_burdened", 
          "median_home_value", "avg_prop_tax", "res_vac", "avg_vac_r", "vacancy_rate", 
          "num_foreclosures", "iso.a", "iso.b", "iso.h")



m_re <- master.all[sub2]

m_re[is.na(m_re)] <- 0

#correct for direction and scale

m_re$multiunit_struct <- rescale(m_re$multiunit_struct, to = c(100,0))
m_re$mobile_home_rate <- rescale(m_re$mobile_home_rate, to = c(100,0))
m_re$percent_crowded <- rescale(m_re$percent_crowded, to = c(100,0))
m_re$percent_renter <- rescale(m_re$percent_renter, to = c(100,0))
m_re$num_households_20yrs <- rescale(m_re$num_households_20yrs, to = c(0, 100))
m_re$occupancy_rate <- rescale(m_re$num_households_20yrs, to = c(0, 100))
m_re$median_rent <- rescale(m_re$median_rent, to = c(100,0))
m_re$percent_housing_cost_burdened <- rescale(m_re$percent_housing_cost_burdened, to = c(100,0))
m_re$median_home_value <- rescale(m_re$median_home_value, to = c(0, 100))
m_re$avg_prop_tax <- rescale(m_re$avg_prop_tax, to = c(0, 100))
m_re$res_vac <- rescale(m_re$res_vac, to = c(100,0))
m_re$avg_vac_r <- rescale(m_re$res_vac, to = c(100,0))
m_re$vacancy_rate <- rescale(m_re$vacancy_rate, to = c(100,0))
m_re$num_foreclosures <- rescale(m_re$num_foreclosures, to = c(100,0))
m_re$iso.a <- rescale(m_re$iso.a, to = c(100,0))
m_re$iso.b <- rescale(m_re$iso.b, to = c(100,0))
m_re$iso.h <- rescale(m_re$iso.h, to = c(100,0))



m_re$index <- (m_re$multiunit_struct + m_re$mobile_home_rate + m_re$percent_crowded + m_re$percent_renter 
               + m_re$num_households_20yrs + m_re$occupancy_rate + m_re$median_rent + m_re$percent_housing_cost_burdened
               + m_re$median_home_value + m_re$avg_prop_tax+ m_re$res_vac + m_re$avg_vac_r + m_re$vacancy_rate
               + m_re$num_foreclosures + m_re$iso.a + m_re$iso.b + m_re$iso.h) / 17

## Physical Environment

sub3 <- c("SSN", "pct_h_den_res",  "pct_res_urb", "pct_com_urb", "pct_ind_urb", "bike_path_ft_p_mile",
          "bikes_ft_p_mile", "ndvi")

m_pe <- master.all[sub3]

m_pe$pct_h_den_res = rescale(m_pe$pct_h_den_res, to = c(100,0))
m_pe$pct_res_urb = rescale(m_pe$pct_res_urb, to = c(100,0))
m_pe$pct_com_urb = rescale(m_pe$pct_com_urb, to = c(100,0))
m_pe$pct_ind_urb = rescale(m_pe$pct_ind_urb, to = c(0,100))
m_pe$bike_path_ft_p_mile = rescale(m_pe$bike_path_ft_p_mile, to = c(0,100))
m_pe$bikes_ft_p_mile = rescale(m_pe$bikes_ft_p_mile, to = c(0,100))
m_pe$ndvi = rescale(m_pe$ndvi, to = c(0,100))

m_pe$index = (m_pe$pct_h_den_res + m_pe$pct_res_urb + m_pe$pct_com_urb + m_pe$pct_ind_urb
              + m_pe$bike_path_ft_p_mile + m_pe$bikes_ft_p_mile + m_pe$ndvi) / 7


## Health Service

sub4 <- c("SSN", "average_d_naloxone", "average_d_syringe", "syr_prop_under_10mi", "avg_MOUD_min_dist", 
          "MOUD_prop_under_10mi", "avg_SUT_min_dist", "SUT_prop_under_10mi", "mental_hlth_dist")

m_he <- master.all[sub4]

m_he$average_d_naloxone = rescale(m_he$average_d_naloxone, to = c(100,0))
m_he$average_d_syringe = rescale(m_he$average_d_syringe, to = c(100,0))
m_he$syr_prop_under_10mi = rescale(m_he$syr_prop_under_10mi, to = c(0,100))
m_he$avg_MOUD_min_dist = rescale(m_he$avg_MOUD_min_dist, to = c(100,0))
m_he$MOUD_prop_under_10mi = rescale(m_he$MOUD_prop_under_10mi, to = c(0, 100))
m_he$avg_SUT_min_dist = rescale(m_he$avg_SUT_min_dist, to = c(100,0))
m_he$SUT_prop_under_10mi = rescale(m_he$SUT_prop_under_10mi, to = c(0,100))
m_he$mental_hlth_dist = rescale(m_he$mental_hlth_dist, to = c(100,0))



m_he$index = (m_he$average_d_naloxone + m_he$average_d_syringe + m_he$syr_prop_under_10mi + m_he$avg_MOUD_min_dist
              + m_he$MOUD_prop_under_10mi + m_he$avg_SUT_min_dist + m_he$SUT_prop_under_10mi
              + m_he$mental_hlth_dist) / 8


## community particpation

sub5 <- c("SSN", "avg_vol_opp", "average_d_adultEd", "cultural_dist")

m_co <- master.all[sub5]


m_co$avg_vol_opp <- rescale(m_co$avg_vol_opp, to = c(0,100))
m_co$average_d_adultEd <- rescale(m_co$average_d_adultEd, to = c(100,0))
m_co$cultural_dist <- rescale(m_co$cultural_dist, to = c(100,0))


m_co$index <- (m_co$avg_vol_opp + m_co$average_d_adultEd + m_co$cultural_dist) / 3


## strength of community economy

sub6 <- c("SSN", "income_per_capita", "employment_per_capita", "percent_SNAP", "expenditure_sum")

m_econ <- master.all[sub6]


m_econ$income_per_capita <- rescale(m_econ$income_per_capita, to = c(0,100))
m_econ$employment_per_capita <- rescale(m_econ$employment_per_capita, to = c(0,100))
m_econ$percent_SNAP <- rescale(m_econ$percent_SNAP, to = c(100,0))
m_econ$expenditure_sum <- rescale(m_econ$expenditure_sum, to = c(0,100))

m_econ$index <- (m_econ$income_per_capita + m_econ$employment_per_capita
                 + m_econ$percent_SNAP) / 4




## master
master_index <- as.data.frame(master.all$SSN)

master_index$index <- (m_ce$index + m_co$index + m_econ$index + m_he$index +
                         m_pe$index + m_re$index) / 6

master_index <- rename(master_index, SSN = `master.all$SSN`)


master_index$ce <- m_ce$index
master_index$co <- m_co$index
master_index$econ <- m_econ$index
master_index$he <- m_he$index
master_index$pe <- m_pe$index
master_index$re <- m_re$index




### Join with shp

## Read NJ municipalities

setwd("~/Documents/HEROP/municipalities.shp?")

nj_municipal <- read_sf("Govt_admin_mun_coast_bnd.shp")

st_crs(nj_municipal)


nj_municipal$SSN <- as.numeric(nj_municipal$SSN)

index_sf <- merge(nj_municipal, master_index, by = "SSN")

st_is_valid(index_sf)

index_sf = st_make_valid(index_sf)

st_is_valid(index_sf)


st_crs(index_sf)

#setwd("~/Documents/HEROP")

#st_write(index_sf, "index.shp", append = TRUE)



tm_shape(index_sf) + tm_fill(col = "index", style = "jenks")



CE <- tm_shape(index_sf) + tm_fill("ce", n=4, palette = "BuPu", style = "jenks", title = "Commercial Environment") + 
  tm_borders(alpha=.4) + 
  tm_layout(legend.text.size = .8, legend.title.size = 1.0, legend.position = c("left", "bottom"), frame = FALSE) + tm_compass(position = c("left", "top")) + tm_scale_bar(position = c("left", "BOTTOM"))

CO <- tm_shape(index_sf) + tm_fill("co", n=4, palette = "BuPu", style = "jenks", title = "Community Participation") + 
  tm_borders(alpha=.4) + 
  tm_layout(legend.text.size = .8, legend.title.size = 1.0, legend.position = c("left", "bottom"), frame = FALSE) + tm_compass(position = c("left", "top")) + tm_scale_bar(position = c("left", "BOTTOM"))

ECON <- tm_shape(index_sf) + tm_fill("econ", n=4, palette = "BuPu", style = "jenks", title = "Strength of Economy") + 
  tm_borders(alpha=.4) + 
  tm_layout(legend.text.size = .8, legend.title.size = 1.0, legend.position = c("left", "bottom"), frame = FALSE) + tm_compass(position = c("left", "top")) + tm_scale_bar(position = c("left", "BOTTOM"))

HE <- tm_shape(index_sf) + tm_fill("he", n=4, palette = "BuPu", style = "jenks", title = "Health Service Availability") + 
  tm_borders(alpha=.4) + 
  tm_layout(legend.text.size = .8, legend.title.size = 1.0, legend.position = c("left", "bottom"), frame = FALSE) + tm_compass(position = c("left", "top")) + tm_scale_bar(position = c("left", "BOTTOM"))

PE <- tm_shape(index_sf) + tm_fill("pe", n=4, palette = "BuPu", style = "jenks", title = "Physical Environment") + 
  tm_borders(alpha=.4) + 
  tm_layout(legend.text.size = .8, legend.title.size = 1.0, legend.position = c("left", "bottom"), frame = FALSE) + tm_compass(position = c("left", "top")) + tm_scale_bar(position = c("left", "BOTTOM"))

RE <- tm_shape(index_sf) + tm_fill("re", n=4, palette = "BuPu", style = "jenks", title = "Residential Environment") + 
  tm_borders(alpha=.4) + 
  tm_layout(legend.text.size = .8, legend.title.size = 1.0, legend.position = c("left", "bottom"), frame = FALSE) + tm_compass(position = c("left", "top")) + tm_scale_bar(position = c("left", "BOTTOM"))



tmap_arrange(CE, CO)


plot(CE)







# Palette of 4colors
library(RColorBrewer)
colors <- brewer.pal(9, "Blues") 
colors <- colorRampPalette(colors)(5)

# Attribute the appropriate color to each country
score <- cut(index_sf$index, 5)
colors <- colors[as.numeric(score)]

# Make the plot
plot(index_sf$index, col=colors ,  bg = "#A6CAE0")




