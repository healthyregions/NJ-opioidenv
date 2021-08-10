
### foreclosures

#read data

setwd("~/Documents/GitHub/NJ-opioidenv/data_raw")
foreclosure_data <- read_excel("Neighborhood_Foreclosure_Data.xlsx")

foreclosure_data <- rename(foreclosure_data, TRACTID = tractcode)

foreclosure_data$TRACTID <- as.numeric(foreclosure_data$TRACTID)


# read cw
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")

### merge
cw_merge <- left_join(cw, foreclosure_data, by = "TRACTID")


### new

sub <- c("SSN", "estimated_foreclosure_rate", "estimated_number_foreclosures", "prop_of_ct")

new <- cw_merge[sub]

new$num_foreclosures <- new$estimated_number_foreclosures * new$prop_of_ct

new$foreclosure_rate <- new$estimated_foreclosure_rate * new$prop_of_ct

# agg

final1 <- aggregate(new$num_foreclosures, by=list(SSN=new$SSN), FUN=sum)
final1 <- rename(final1, num_foreclosures = x)


final2 <- aggregate(new$foreclosure_rate, by=list(SSN=new$SSN), FUN=sum)
final2 <- rename(final2, foreclosure_rate = x)


#join

final <- merge(final1, final2, by = "SSN")



### Save

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(final, "foreclosures.csv", row.names = FALSE) 



### Merge to master

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
foreclosures <- read.csv("foreclosures.csv.csv")
master <- read.csv("master_clean.csv")

master_updated <- merge(master, foreclosures, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master, "master_clean.csv", row.names = FALSE) 









