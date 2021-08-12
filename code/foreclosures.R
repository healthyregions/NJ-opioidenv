


### foreclosures

#read data

setwd("~/Documents/HEROP")
foreclosure_data <- read.csv("foreclosures.csv")

foreclosure_data <- rename(foreclosure_data, TRACTID = geoid)

foreclosure_data$TRACTID <- as.numeric(foreclosure_data$TRACTID)

foreclosure_data$fordq_num <- as.numeric(substr(foreclosure_data$fordq_num, 1, 3))
foreclosure_data$fordq_rate <- as.numeric(foreclosure_data$fordq_rate )




# read cw
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")

### merge
cw_merge <- left_join(cw, foreclosure_data, by = "TRACTID")


### new

sub <- c("SSN", "fordq_num", "fordq_rate", "prop_of_ct")

new <- cw_merge[sub]

new$num_foreclosures <- new$fordq_num * new$prop_of_ct

new$foreclosure_rate <- new$fordq_rate * new$prop_of_ct

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
foreclosures <- read.csv("foreclosures.csv")
master <- read.csv("master_clean.csv")

master_updated <- merge(master, foreclosures, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "master_clean.csv", row.names = FALSE) 









