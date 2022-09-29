
#setwd("~/Code/NJ-opioidenv/code")

me <- read.csv("~/Downloads/me_data_geocode_complete.csv")
head(me)
dim(me) #7496

me <- me %>% 
  filter(!is.na(AGE))
dim(me) #7492


me$AGE <- me$AGE %>% 
  substr(1,2) %>% #only takes first two characters: numeric age (previously there was "Years")
  as.numeric() 

unique(me$RACE)
me$RACE[me$RACE == "black"] <- "Black"
me$RACE[me$RACE == "Asian"] <- "Asian/Pacific"
me$RACE[me$RACE == "OTHER"] <- "Other"

summary(me$AGE)  #min age = 1, med = 39, mean = 40.5, max = 85.00

head(me)

### Visualizations
library(ggplot2)
ggplot(me, aes(x=AGE)) + 
  geom_histogram(binwidth = 1, color="black", fill="white")

ggplot(me, aes(x=AGE, fill=RACE)) + 
  geom_histogram(binwidth = 1, color="black")

ggplot(me, aes(x=AGE)) + 
  geom_histogram(binwidth = 1, color="black", fill="white") + 
  facet_wrap( ~ RACE)

head(me)
dim(me)

##Reshape to Aggregate by Race&Year
meSummary<- me %>%
  group_by(RACE, YEAR) %>%
  summarise(AveAge = mean(AGE, na.rm = TRUE),
            Total = n(),
            Prop = (n()/7492)*100,
            FentProp = (sum(Fentanyl/7492, na.rm = TRUE))*100,
            HeroProp = (sum(Heroin/7492, na.rm = TRUE))*100,
            Oxycodone = (sum(Oxycodone/7492, na.rm = TRUE))*100,
            Morphine = (sum(Morphine/7492, na.rm = TRUE))*100,
            Methadone = (sum(Morphine/7492, na.rm = TRUE))*100)


##Reshape to Aggregate by Race&Year
meSummary<- me %>%
  group_by(RACE, YEAR) %>%
  summarise(AveAge = mean(AGE, na.rm = TRUE),
            Total = n(),
            Prop = (n()/7492)*100,
            FentProp = (sum(Fentanyl/7492, na.rm = TRUE))*100,
            HeroProp = (sum(Heroin/7492, na.rm = TRUE))*100,
            Oxycodone = (sum(Oxycodone/7492, na.rm = TRUE))*100,
            Morphine = (sum(Morphine/7492, na.rm = TRUE))*100,
            Methadone = (sum(Morphine/7492, na.rm = TRUE))*100)
head(meSummary)

meSummary<- me %>%
  group_by(AGE) %>%
  summarise(Total = n(),
            Prop = (n()/7492)*100,
            FentProp = (sum(Fentanyl/7492, na.rm = TRUE))*100,
            HeroProp = (sum(Heroin/7492, na.rm = TRUE))*100,
            Oxycodone = (sum(Oxycodone/7492, na.rm = TRUE))*100,
            Morphine = (sum(Morphine/7492, na.rm = TRUE))*100,
            Methadone = (sum(Morphine/7492, na.rm = TRUE))*100)
head(meSummary)

meSummary <- as.numeric(me$AGE)

meSummary<- me %>%
  group_by(AGE<15) %>%
  summarise(Total = n(),
           Prop = (n()/7492)*100,
           FentProp = (sum(Fentanyl/7492, na.rm = TRUE))*100,
           HeroProp = (sum(Heroin/7492, na.rm = TRUE))*100,
           Oxycodone = (sum(Oxycodone/7492, na.rm = TRUE))*100,
           Morphine = (sum(Morphine/7492, na.rm = TRUE))*100,
           Methadone = (sum(Morphine/7492, na.rm = TRUE))*100)
head(meSummary)

view(meSummary)
head(meSummary)
dim(meSummary) #27rows

ggplot(meSummary, aes(x=YEAR, y=FentProp, group = RACE, color = RACE)) +
  geom_line() + 
  geom_point() +
  xlab("") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) 


ggplot(meSummary, aes(x=YEAR, y=HeroProp, group = RACE, color = RACE)) +
  geom_line() + 
  geom_point() +
  xlab("") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) 


meSummary2 <- meSummary %>% filter(Prop > 1)
sum(meSummary2$Total) #7299 = 97.4% of all data
ggplot(meSummary2, aes(x=YEAR, y=AveAge, group = RACE, color = RACE)) +
  geom_line() + 
  geom_point() +
  ylab("Average Age at Time of Death") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) 


ggplot(meSummary2, aes(x=YEAR, y=HeroProp, group = RACE, color = RACE)) +
  geom_line() + 
  geom_point() +
  ylab("% Overdose Deaths with Heroin") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) 
  

ggplot(meSummary2, aes(x=YEAR, y=FentProp, group = RACE, color = RACE)) +
  geom_line() + 
  geom_point() +
  ylab("% Overdose Deaths with Fentanyl") +
  theme(axis.text.x=element_text(angle=60, hjust=1)) 


#####
library(sf)
library(tmap)
library(tidyverse)

njmaster <- st_read("~/Code/NJ-opioidenv/data_raw/Municipal_Boundaries_of_NJ.shp")
st_crs(njmaster) #EPSG 3424

me.pt <- st_as_sf(me,
                  coords = c("Longitude","Latitude"),
                  crs = st_crs(4326))

me.pt <- st_transform(me.pt,3424)

head(njmaster)

me.pt.filter <- me.pt[njmaster,]
dim(me.pt.filter) #7284 
tm_shape(njmaster) + tm_fill() +
  tm_shape(me.pt.filter) + tm_dots()

head(me.pt.filter)

memuni <- st_join(me.pt.filter,njmaster)
memuni <- st_drop_geometry(memuni)
dim(memuni) #7284

memuni$SSN <- as.factor(memuni$SSN)

me.muni.final <- memuni %>%
  group_by(SSN) %>%
  summarize(AveAge = mean(AGE, na.rm = TRUE),
            TotalDeaths = n(),
            Prop = (n()/7492)*100,
            FentProp = (sum(Fentanyl/7492, na.rm = TRUE))*100,
            HeroProp = (sum(Heroin/7492, na.rm = TRUE))*100,
            Oxycodone = (sum(Oxycodone/7492, na.rm = TRUE))*100,
            Morphine = (sum(Morphine/7492, na.rm = TRUE))*100,
            Methadone = (sum(Morphine/7492, na.rm = TRUE))*100)
  
dim(me.muni.final) #504
head(me.muni.final)

test <- merge(njmaster, me.muni.final, by = "SSN")
head(test)
tm_shape(test) + tm_fill("AveAge", style = "quantile")

summary(me.muni.final2$AveAge)


me.muni.final2 <- memuni %>%
  group_by(SSN) %>%
  summarize(TotalDeaths = n(),
            PropDeaths = (TotalDeaths / 7288) * 100,
            TotalDeath15 = sum(YEAR == 2015),
            TotalDeath16 = sum(YEAR == 2016),
            TotalDeath17 = sum(YEAR == 2017),
            TotalDeath18 = sum(YEAR == 2018),
            da04 = (sum(AGE <= 4)),
            da59 = (sum(AGE > 4 & AGE <= 9)),
            da1014 = (sum(AGE > 10 & AGE <= 14)), 
            da1520 = (sum(AGE > 15 & AGE <= 20)),
            da2024 = (sum(AGE > 20 & AGE <= 24)),
            da2529 = (sum(AGE > 25 & AGE <= 29)),
            da3034 = (sum(AGE > 30 & AGE <= 34)),
            da3539 = (sum(AGE > 35 & AGE <= 39)),
            da4044 = (sum(AGE > 40 & AGE <= 44)),
            da4549 = (sum(AGE > 45 & AGE <= 49)),
            da5054 = (sum(AGE > 50 & AGE <= 54)),
            da5559 = (sum(AGE > 55 & AGE <= 59)),
            da6064 = (sum(AGE > 60 & AGE <= 64)),
            da6569 = (sum(AGE > 65 & AGE <= 69)),
            da7074 = (sum(AGE > 70 & AGE <= 74)),
            da7580 = (sum(AGE > 75 & AGE <= 80)),
            da8085 = (sum(AGE > 80 & AGE <= 85)),
            da885 = (sum(AGE > 85)),
            FentW = sum(Fentanyl == 1 & RACE == "White", na.rm = TRUE),
            FentB = sum(Fentanyl == 1 & RACE == "Black", na.rm = TRUE),
            FentH = sum(Fentanyl == 1  & RACE == "Hispanic", na.rm = TRUE),
            TotalFent = sum(Fentanyl == 1, na.rm = TRUE),
            TotalFent15 = sum(YEAR == 2015, Fentanyl == 1, na.rm = TRUE),
            TotalFent16 = sum(YEAR == 2016, Fentanyl == 1, na.rm = TRUE),
            TotalFent17 = sum(YEAR == 2017, Fentanyl == 1, na.rm = TRUE),
            TotalFent18 = sum(YEAR == 2018, Fentanyl == 1, na.rm = TRUE),
            HeroinW = sum(Heroin == 1 & RACE == "White", na.rm = TRUE),
            HeroinB = sum(Heroin == 1 & RACE == "Black", na.rm = TRUE),
            HeroinH = sum(Heroin == 1  & RACE == "Hispanic", na.rm = TRUE),
            TotalHero = sum(Heroin == 1, na.rm = TRUE),
            TotalHero15 = sum(YEAR == 2015, Heroin == 1, na.rm = TRUE),
            TotalHero16 = sum(YEAR == 2016, Heroin == 1, na.rm = TRUE),
            TotalHero17 = sum(YEAR == 2017, Heroin == 1, na.rm = TRUE),
            TotalHero18 = sum(YEAR == 2018, Heroin == 1, na.rm = TRUE),
            TotalOxy = sum(Oxycodone == 1, na.rm = TRUE),
            TotalOxy15 = sum(Oxycodone == 1 & YEAR == 2015, na.rm = TRUE),
            TotalOxyt16 = sum(Oxycodone == 1 & YEAR == 2016, na.rm = TRUE),
            TotalOxyt17 = sum(Oxycodone == 1 & YEAR == 2017, na.rm = TRUE),
            TotalOxyt18 = sum(Oxycodone == 1 & YEAR == 2018, na.rm = TRUE),
            TotalMorph = sum(Morphine == 1, na.rm = TRUE),
            TotalMorp15 = sum(Morphine == 1 & YEAR == 2015, na.rm = TRUE),
            TotalMorp16 = sum(Morphine == 1 & YEAR == 2016, na.rm = TRUE),
            TotalMorp17 = sum(Morphine == 1 & YEAR == 2017, na.rm = TRUE),
            TotalMorp18 = sum(Morphine == 1 & YEAR == 2018, na.rm = TRUE),
            TotalMeth= sum(Methadone == 1, na.rm = TRUE),
            TotalMeth15 = sum(Methadone == 1 & YEAR == 2018, na.rm = TRUE),
            TotalMeth16 = sum(Methadone == 1 & YEAR == 2018, na.rm = TRUE),
            TotalMeth17 = sum(Methadone == 1 & YEAR == 2018, na.rm = TRUE),
            TotalMeth18 = sum(Methadone == 1 & YEAR == 2018, na.rm = TRUE),
            Fent15W = sum(Fentanyl == 1 & YEAR == 2015 & RACE == "White", na.rm = TRUE),
            Fent15B = sum(Fentanyl == 1 & YEAR == 2015 & RACE == "Black", na.rm = TRUE),
            Fent15H = sum(Fentanyl == 1 & YEAR == 2015 & RACE == "Hispanic", na.rm = TRUE),
            Hero15W = sum(Heroin & YEAR == 2015 & RACE == "White", na.rm = TRUE),
            Hero15B = sum(Heroin & YEAR == 2015 & RACE == "Black", na.rm = TRUE),
            Hero15H = sum(Heroin & YEAR == 2015 & RACE == "Hispanic", na.rm = TRUE),
            Fent18W = sum(Fentanyl == 1 & YEAR == 2018 & RACE == "White", na.rm = TRUE),
            Fent18B = sum(Fentanyl == 1 & YEAR == 2018 & RACE == "Black", na.rm = TRUE),
            Fent18H = sum(Fentanyl == 1 & YEAR == 2018 & RACE == "Hispanic", na.rm = TRUE), 
            Hero18W = sum(Heroin == 1 & YEAR == 2018 & RACE == "White", na.rm = TRUE),
            Hero18B = sum(Heroin == 1 & YEAR == 2018 & RACE == "Black", na.rm = TRUE),
            Hero15H = sum(Heroin == 1& YEAR == 2018 & RACE == "Hispanic", na.rm = TRUE))
            
head(me.muni.final2)
glimpse(me.muni.final2)
summary(me.muni.final2$PropDeaths)

write.csv(me.muni.final2, "SSN-tempmaster.csv")

test <- merge(njmaster, me.muni.final2, by = "SSN")
head(test)
tm_shape(test) + tm_fill("PropDeaths", style = "jenks")


###
agedata <- read.csv("~/Code/NJ-opioidenv/data_in_progress/NJ_1564yoAJ.csv")

temp <- merge(me.muni.final2,agedata, by = "SSN")
glimpse(temp)

#Ave Crude Rate = 43.137 per 100,000
mean(temp$TotalDeaths / (temp$pop18_1564*4))*100000

#Add Crude Rate per Municipality
temp$CrudeRate <- (temp$TotalDeaths / (temp$pop18_1564*4)) * 100000
summary(temp$CrudeRate)

temp$CrudeRate <- (temp$TotalDeaths / (temp$pop18_1564*4)) * 100000

temp$CrudeRt_04 <- temp$da04 / temp$a04 * 10000
temp$CrudeRt_a59 <- temp$da59 / temp$a59 * 10000
temp$CrudeRt_a1014 <- temp$da1014 / temp$a1014 * 10000
temp$CrudeRt_a1520 <- temp$da1520 / temp$a1520 * 10000
temp$CrudeRt_a2024 <- temp$da2024 / temp$a2024 * 10000
temp$CrudeRt_a2529 <- temp$da2529 / temp$a2529 * 10000
temp$CrudeRt_a3034 <- temp$da3034 / temp$a3034 * 10000
temp$CrudeRt_a3539 <- temp$da3539 / temp$a3539 * 10000
temp$CrudeRt_a4044 <- temp$da4044 / temp$a4044 * 10000
temp$CrudeRt_a4549 <- temp$da4549 / temp$a4549 * 10000
temp$CrudeRt_a5054 <- temp$da5054 / temp$a5054 * 10000
temp$CrudeRt_a5559 <- temp$da5559 / temp$a5559 * 10000
temp$CrudeRt_a6064 <- temp$da6064 / temp$a6064 * 10000
temp$CrudeRt_a6569 <- temp$da6569 / temp$a6569 * 10000
temp$CrudeRt_a7074 <- temp$da7074 / temp$a7074 * 10000
temp$CrudeRt_a7580 <- temp$da7580 / temp$a7580 * 10000
#temp$CrudeRt_a8084 <- temp$da8084 / temp$a8084 * 100000
#temp$CrudeRt_a85 <- temp$da85 / temp$a85 * 100000

glimpse(temp)

###Direct method
mean(temp$CrudeRt_a3539)
*0.013818, na.omit=TRUE)

write.csv(temp, "crudert_foradjusting.csv")

####Indirect method
# Take standard mortality age-adj rate for NJ 
# temp$Expected = AgeGroupMortRt * temp$totPop18 
# temp$SMRatio = temp$Observed / temp$Expected 
# temp$AdjRate = MortRt * temp$SMRatio




# SSN, alldeaths, FentDeaths_Yr, FentDeathsBlck_Yr, FentDeathsWht_Yr, FenthDeathsHisp_Yr)...  
test <- merge(njmaster, me.muni.final, by = "SSN")
tm_shape(test) + tm_fill("AveAge")
  
str(memuni$SSN)
summary(memuni$SSN) #all NAs.
memuni2 <- subset(memuni, na.omit(memuni$SSN))
dim(memuni2) #7492
