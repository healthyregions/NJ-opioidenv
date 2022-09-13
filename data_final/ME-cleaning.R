
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
  
