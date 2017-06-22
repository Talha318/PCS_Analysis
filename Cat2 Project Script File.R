#install necessary packages
require(qdap)
require(dplyr)
require(caTools)
require(stringr)

#Loading Raw data set

MasterData = read.csv("Raw Learning Data.csv" , header=TRUE)
df = MasterData

#convert data into character type
df$Text = as.character(df$Text)
df$Identifier = as.character(df$Identifier)
df$Level = as.character(df$Level)
df$Category = as.factor(df$Category)   #"Category" needs to be factor for easy manipulation

#Converting all text to lower case
df$Text = str_to_lower(df$Text, locale = "en")

#identifing dupilicates
TextDup = df$Text[which(duplicated(df$Identifier))]

#removing duplicates in identifier
df = df[-c(which(duplicated(df$Identifier))), ]

#Renumbering rows in data set
row.names(df) = 1:nrow(df)

#word count of regulation text
df$wordcount = str_count(df$Text, "\\S+")

#Splitting Data into testing and training sets
#set.seed(123)
#dt = sort(sample(nrow(df), nrow(df)*.7))
#dfTr = df[dt,] 
#Test = df[-dt,]
dfTr = df

#Creating Features / key words and phrases that suggest actionability
df$shall = str_detect(df[,3],"shall")
df$shall_submit = str_detect(df[,3],"shall submit")
df$permittee_shall = str_detect(df[,3],"permittee shall")
df$permittee_must = str_detect(df[,3],"permittee must")
df$owner_or_operator = str_detect(df[,3],"owner or operator")
df$owner_operator = str_detect(df[,3],"owner/operator")

#Subsetting separating categories
dfActionable = subset(dfTr, Category == "Actionable") 
dfDef = subset(dfTr, Category == "NA - Definition") 
dfOther = subset(dfTr, Category == "NA - Other") 
dfTrig = subset(dfTr, Category == "Trigger") 
dfUnCat = subset(dfTr, Category == "")
