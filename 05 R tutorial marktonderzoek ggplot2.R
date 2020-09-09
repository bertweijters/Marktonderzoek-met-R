################## INTRO TO GGPLOT2 ############
#install package and open library
install.packages("ggplot2")
library(ggplot2)

############# EXAMPLE 1 - CARS
#read in some data (inbuilt data)
cars<-mtcars

#check data structure
str(cars)

#Create graphs in ggplot2
#basic histogram
ggplot(cars,aes(x=mpg))+
  geom_histogram()

#basic scatter plot
ggplot(cars,aes(x=wt,y=mpg))+
  geom_point()

#for some plotting, it is best to specify categorical variables as 'factors'
#create a transmission factor
cars$tm<-factor(cars$am,c(0,1),labels=c("automatic","manual"))

#for more extensive plotting, 
#assign the basic aesthetics to the objecct t you can then use in subsequent calls
t<-ggplot(cars,aes(wt,mpg))

#scatter plot of wt and mpg by transmission and number of cylinders with trend line
t+
  geom_point(size = 4,alpha=.8, aes(shape=tm,col=cyl))+
  geom_smooth(method="lm",se=FALSE)

#add labels to dots in scatter plot
t+
  geom_jitter(aes(shape=tm,col=cyl))+
  geom_smooth(method="lm")+
  geom_text(aes(label=rownames(cars)),check_overlap=TRUE,nudge_y=.5)

#faceting
t+
  geom_jitter(aes(col=cyl))+
  geom_smooth(method="lm")+
  facet_grid(cols = vars(tm))

#using themes
install.packages("jtools")
library(jtools)
ggplot(mtcars, aes(x = wt, y = mpg, group = factor(cyl))) +
  geom_point()+
  geom_smooth(method="lm",color="black")+
  theme_apa()

#Export plot to working directory
#assign the to-be-exported plot to an object you can refer to, called exportplot
exportplot<-
  t+
  geom_jitter(aes(col=cyl))+
  geom_smooth(method="lm")+
  facet_grid(cols = vars(tm))

#check plot
exportplot

#set working directory
setwd("C:/Users/bweijter/Desktop")

#Export plot to working directory 
png('rplot.png')
plot(exportplot)
dev.off()



######### FURTHER EXAMPLES ######################################
#check inbuilt dataframe mile per gallon
#Note: factors are labeled
str(mpg)

############## PART 1 - Quick plotting with the qplot function####################???
#univariate: histogram
qplot(hwy, data=mpg)
#histogram by factor level
qplot(hwy, data=mpg,fill = drv)

#bivariate: plot highway mileage as a function of engine displacement (in litres)
qplot(displ,hwy,data=mpg)
#use factor level to change the aesthetics of the dots
#by color 
qplot(displ,hwy,data=mpg, color=drv)
#by shape
qplot(displ,hwy,data=mpg, shape=drv)
#by size
qplot(displ,hwy,data=mpg, size=cyl)

#add trend lines
#smoothed trend line
qplot(displ,hwy,data=mpg, geom=c("point","smooth"))
#regression line
qplot(displ,hwy,data=mpg, geom=c("point","smooth"),method ="lm")
#regresssion line with log transformed y
qplot(displ,log(hwy),data=mpg, geom=c("point","smooth"),method ="lm")

#split plot based on facets or panels 
#in columns (variable on the right hand side of the ~)
qplot(displ,hwy,data = mpg, facets = .~drv)
#or in rows (variable on the left hand side of the ~)
qplot(displ,hwy,data = mpg, facets = drv~.)


############## PART 2 - ggplot function ####################
#please check https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
ggplot(mpg, aes(hwy,cty))+
  geom_point(aes(color=cyl))+
  geom_smooth(method="lm")

#univariate
#one continuous variable
a<-ggplot(mpg,aes(hwy))
a+geom_area(stat="bin")
a+geom_density(stat="bin")
a+geom_dotplot()
a+geom_freqpoly()
a+geom_histogram(binwidth=1)
#one discrete variable
b<-ggplot(mpg,aes(fl))
b+geom_bar()

#bivariate
f <- ggplot(mpg, aes(cty, hwy))
f + geom_blank()
f + geom_jitter()
f + geom_point()
f + geom_quantile()
f + geom_smooth(method = lm)
f + geom_text(aes(label=model))
#or combined
f + 
  geom_jitter()+ 
  geom_smooth(method = lm)+
  annotate(geom=name)

