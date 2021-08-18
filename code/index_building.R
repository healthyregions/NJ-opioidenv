#INDEX

#install.packages("scales")

library(scales)
library(sf)



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

sub3 <- c("pct_h_den_res",  "pct_res_urb", "pct_com_urb", "pct_ind_urb", "bike_path_ft_p_mile",
          "bikes_ft_p_mile", "ndvi")

m_pe <- master.all[sub3]




