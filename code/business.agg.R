
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

#install.packages("data.table")
library(data.table)

new <- setDT(new, keep.rownames = TRUE)[]


new <- rename(new, SSN = rn)


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