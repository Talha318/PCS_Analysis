#install necessary packages
require(qdap)
require(dplyr)
require(caTools)

#Loading Raw data set

MasterData = read.csv("Raw Learning Data.csv" , header=TRUE)
df = MasterData

#convert data into character type
df$Text = as.character(df$Text)
df$Identifier = as.character(df$Identifier)
df$Level = as.character(df$Level)
df$Category = as.factor(df$Category)   #"Category" needs to be factor for easy manipulation

#Handing Duplicates in identifier
  
  #identifing dupilicates
  TextDup = df$Text[which(duplicated(df$Identifier))]

  #removing duplicates in identifier
  df = df[-c(which(duplicated(df$Identifier))), ]

  
#word count of regulation text
df$wordcount = wc(df$Text)

#Splitting Data into testing and training sets
set.seed(123)
dt = sort(sample(nrow(df), nrow(df)*.7))
dfTr = df[dt,] 
Test = df[-dt,]


#subsetting separating categories
dfActionable = subset(dfTr, Category == "Actionable") 
dfDef = subset(dfTr, Category == "NA - Definition") 
dfOther = subset(dfTr, Category == "NA - Other") 
dfTrig = subset(dfTr, Category == "Trigger") 
dfUnCat = subset(dfTr, Category == "")

  