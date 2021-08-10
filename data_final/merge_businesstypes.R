
#load business data

setwd("~/Documents/Herop")

bus <- read.csv("nj_bus_mun2018.names.csv")


bus$X = NULL
bus$mean_emp_size = NULL
bus$med_emp_size = NULL
bus$mean_sales_vol = NULL
bus$med_sales_vol = NULL
bus$simp_index_emp_size = NULL


prevalent_business_type <- bus[,-1]
rownames(prevalent_business_type) <- bus[,1]

prevalent_business_type$prevalent_type <- colnames(bus)[apply(prevalent_business_type,1,which.max)]

##subset

sub <- c("all_bus", "prevalent_type")

new <- prevalent_business_type[sub]

install.packages("data.table")
library(data.table)

new <- setDT(new, keep.rownames = TRUE)[]


new <- rename(new, SSN = rn)


### merge vacancies

#load vacancies
setwd("~/Documents/GitHub/NJ-opioidenv/data_in_progress")

vacancies <- read.csv("usps_vac_2018_variable.csv")

#load cw
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

cw <- read.csv("cw_areal_interpolation.csv")

cw <- rename(cw, geoid = TRACTID)

cw$SSN <- as.character(cw$SSN)

#merge
cw_merge <- left_join(cw, vacancies, by = "geoid")

cw_merge$Place.Name = NULL
cw_merge$TRACTID = NULL

# weight

cw_merge$weight_vacancy_rate <- cw_merge$prop_of_ct * cw_merge$bus_vac_rate

#agg

final <- aggregate(cw_merge$weight_vacancy_rate, by=list(SSN=cw_merge$SSN), FUN=sum)
final <- rename(final, business_vacancy_rate = x)


### merge vacancies and type


final <- merge(final, new, by = "SSN")

final <- rename(final, all_businesses = all_bus)

#save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(final, "business.data.csv", row.names = FALSE) 





#___________________________________________________________

###Merge to master

setwd("~/Documents/GitHub/NJ-opioidenv/data_final")
bus <- read.csv("business.data.csv")
master <- read.csv("master_clean.csv")

master_updated <- merge(master, bus, by = "SSN")

##save
setwd("~/Documents/GitHub/NJ-opioidenv/data_final")

write.csv(master_updated, "master_clean.csv", row.names = FALSE)





