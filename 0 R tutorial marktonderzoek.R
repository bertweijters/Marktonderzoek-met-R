######## Kennisclips marktonderzoek #####################################################
############ Bert Weijters ###############################################################

#zie ook: R tutorial marktonderzoek.xlsx
#data: testdata.sav

############################ Data importeren en checken
#Data importeren
#Indien nodig pakket haven installeren
#install.packages("haven")
#open haven library
library(haven)
#importeer de .sav file, wijs toe aan object 'testdata', bekijk in de data viewer
#pas het pad naar de file aan aan je eigen pc!
testdata <- read_sav("C:/Users/bweijter/Desktop/0 testdata.sav")
View(testdata)
#verifieer de klasse van testdata: het is een dataframe
class(testdata)
#indien nodig kan je een object (bv. een matrix) als dataframe specifiëren
testdata<-data.frame(testdata)
#verifieer de dimensies van testdata: 399 rijen, 67 kolommen
dim(testdata)
#check de structuur van testdata
str(testdata)
 
########################## Data manipuleren
#observaties selecteren: houd enkel observaties uit loops 1 (appels), 2 (peren) en 3 (appelsienen)
#df (voor 'dataframe') bevat N = 385 observaties (ipv N = 399 in testdata)
df<-testdata[testdata$Loop<4,]
#overzicht van variabelen in df:
colnames(df)
#selecteer variabelen 2 (status) t/m 67
#run dit niet herhaaldelijk, want dan verwijder je telkens een andere variabele
df<-df[,2:67]
#variabele categorizeren
#deel aantal leden huishouden in in drie categorieën
df$HHM_cat<-cut(df$HHMembers,breaks=c(0,1,2,Inf),labels=(c("single","two","more")))
#merk op dat de nieuwe variabele een factor is (categorische variabele met labels)
class(df$HHM_cat)
#Variabelen creëren obvmultivariate condities
#creëer een marker variabele voor single mannen
df$singlemale<-(df$HHM_cat=="single")&(df$Gender==1)
#variabelen Variabelen berekenen uit som van meerdere variabelen
#bereken totaal aandeel (/10) van online betalingen (zowel mobiel als op pc/laptop/..)
df$onlinepay<-df$q12_1c1+df$q12_2c1
#Codeer 'niet van toepassing' als NA in nieuwe variabele
#vervang waarde 1 ('niet van toepassing') door NA in de  variabele
df$q6p1_1[df$q6p1_1==1]<-NA

############################### Variabelen samenvatten - univariaat
#overzicht van alle variabelen in dataframe met beschrijvende statistieken
summary(df)
#Frequentietabel en -kolomgrafiek: 1 categorische variabele
table(df$HHM_cat)
plot(df$HHM_cat) 

#Descriptieve statistieken en boxplot: 1 continue variabele 
#gemiddelde, standaarddeviatie, mediaan, minimum, maximum
mean(df$onlinepay)
sd(df$onlinepay)
median(df$onlinepay)
min(df$onlinepay)
max(df$onlinepay)
#univariate grafieken: boxplot en histogram
boxplot(df$onlinepay)
hist(df$onlinepay)

##########################Relaties tussen variabelen (bivariaat)	
#relatie tussen intervalvariabelen: correlatie en scatter plot	correl()
#correlation met stat toets
cor(df$onlinepay,df$q8_1+df$q8_2)
cor.test(df$onlinepay,df$q8_1+df$q8_2)
#scatter plot, basic of met noise voor leesbaarheid (jitter)
plot(df$onlinepay,df$q8_1+df$q8_2)
plot(jitter(df$onlinepay),jitter(df$q8_1+df$q8_2))

#Interval variabele ifv categoriën: beschrijvend	by(data,indices, function)
by(df$onlinepay, df$HHM_cat,mean)
aggregate(df$onlinepay,by=list(householdtype=df$HHM_cat),mean)
plot(df$onlinepay~df$HHM_cat)
#Interval variabele ifv categoriën: toetsen
anova<-aov(df$onlinepay~df$HHM_cat)
summary(anova)
model.tables(anova, "means")
TukeyHSD(anova)

#Contingentietabel: 2 categorische variabelen	
#contingentietabel in base R
table(df$HHM_cat,df$Loop)
barplot(table(df$HHM_cat,df$Loop),beside=T,legend=T)
chisq.test(table(df$HHM_cat,df$Loop))

#contingentietabel in dplyr
#(installeer &) open dplyr library
#install.packages("dplyr")
library(dplyr)

#voor dit voorbeeld gebruiken we andere data, nl. de cars data
df<-mtcars
#exploreer data
head(df)
str(df)

#aantal cylinders ifv automatic vs manual transmission
#selecteer de relevante variabelen
dfsel <- select(df,c(am,cyl))

#sorteer de cases op de x variabele
dfsel<-arrange(dfsel,am)

#bereken frequentie en proportie per cel
dfsel %>% 
  group_by(am,cyl) %>% 
  summarize(n=n())%>%
  mutate(freq=n/sum(n))

#sla deze frequentietabel ev. op als tabel  
data_freq<-dfsel %>% 
  group_by(am,cyl) %>% 
  summarize(n=n())%>%
  mutate(freq=n/sum(n))
#exporteer als excel-leesbare csv file
write.csv(x=data_freq,file="C:/Users/Public/Downloads/freq_data.csv")



