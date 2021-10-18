


### residential foreclosures

#read data

setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
library(readxl)
foreclosure_data <- read_excel("Neighborhood_Foreclosure_Data.xlsx")

foreclosure_data <- rename(foreclosure_data, TRACTID = tractcode)

foreclosure_data$TRACTID <- as.numeric(foreclosure_data$TRACTID)


# read cw
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")

### merge
cw_merge <- left_join(cw, foreclosure_data, by = "TRACTID")


### new

sub <- c("SSN", "estimated_number_foreclosures", "estimated_number_mortgages", "prop_of_ct")

new <- cw_merge[sub]

new$num_foreclosures_res <- new$estimated_number_foreclosures * new$prop_of_ct
new$num_mortgages_tract <- new$estimated_number_mortgages * new$prop_of_ct


# agg

final1 <- aggregate(new$num_foreclosures_res, by=list(SSN=new$SSN), FUN=sum, na.rm = TRUE)
final1 <- rename(final1, num_foreclosures = x)

final2 <- aggregate(new$num_mortgages_tract, by=list(SSN=new$SSN), FUN=sum, na.rm = TRUE)
final2 <- rename(final2, num_mortgages = x)


### merge

foreclosure_rates <- merge(final1, final2, by = "SSN")
foreclosure_rates$foreclosure_rate_mortgage <- foreclosure_rates$num_foreclosures/ foreclosure_rates$num_mortgages

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
master <- read.csv("working_master(expanded).csv")

foreclosure_rates$forclosure_rate_pop <- foreclosure_rates$num_foreclosures / master$pop2016

#clear NaN
foreclosure_rates$foreclosure_rate_mortgage <- ifelse(foreclosure_rates$foreclosure_rate_mortgage == "NaN", 0, foreclosure_rates$foreclosure_rate_mortgage)


### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(foreclosure_rates, "foreclosures.csv", row.names = FALSE) 



### Merge to masters

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
foreclosures <- read.csv("foreclosures.csv")

master1 <- read.csv("working_master(abridged).csv")
master1$num_foreclosures = NULL

master2 <- read.csv("working_master(expanded).csv")
master2$num_foreclosures = NULL

master3 <- read.csv("working_master(abridged_validation).csv")
master3$num_foreclosures = NULL

sub_foreclosures <- foreclosure_rates[c("forclosure_rate_pop", "foreclosure_rate_mortgage", "SSN")]

master1_updated <- merge(master1, sub_foreclosures, by = "SSN")
master2_updated <- merge(master2, sub_foreclosures, by = "SSN")
master3_updated <- merge(master3, sub_foreclosures, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master1, "working_master(abridged).csv", row.names = FALSE) 
write.csv(master2, "working_master(expanded).csv", row.names = FALSE) 
write.csv(master3, "working_master(abridged_validation).csv", row.names = FALSE) 







