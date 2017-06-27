#install necessary packages
require(qdap)
require(dplyr)
require(caTools)
require(stringr)
library(tm)

#Loading Raw data set
MasterData = read.csv("Raw Learning Data.csv" , header=TRUE, stringsAsFactors = FALSE, encoding = "UTF-8")
df = MasterData



#convert data into character type
df$Text = as.character(df$Text)
df$Identifier = as.character(df$Identifier)
df$Level = as.character(df$Level)
df$Category = as.factor(df$Category)   #"Category" needs to be factor for easy manipulation
df$Category [df$Category != "Actionable"] = "NA - Other" #turning all non-actionable categorizations to na-other for binary classification

#Converting all text to lower case
df$Text = str_to_lower(df$Text, locale = "en")

#identifing duplicates
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

#set a raw text data frame
Text = iconv(df$Text, "UTF-8", "UTF-8",sub="")
Text = as.data.frame(Text)  

#Cleaned Data to create Corpus
dfcorpus = Corpus(DataframeSource(Text))

#removing numbers, punctuation, and english stop words
dfcorpus = tm_map(dfcorpus, removePunctuation)
dfcorpus = tm_map(dfcorpus, removeNumbers)
dfcorpus = tm_map(dfcorpus, removeWords, stopwords("english"))
dfcorpus = tm_map(dfcorpus, stripWhitespace)

#creating document term matrix
df_dtm = DocumentTermMatrix(dfcorpus)
dtm.matrix = as.matrix(df_dtm)

#Creating Features / key words and phrases that suggest actionability
# df$shall = str_detect(df[,3],"shall")
# df$shall_submit = str_detect(df[,3],"shall submit")
# df$permittee_shall = str_detect(df[,3],"permittee shall")
# df$permittee_must = str_detect(df[,3],"permittee must")
# df$owner_or_operator = str_detect(df[,3],"owner or operator")
# df$owner_operator = str_detect(df[,3],"owner/operator")

#Subsetting separating categories
# dfActionable = subset(dfTr, Category == "Actionable") 
# dfDef = subset(dfTr, Category == "NA - Definition") 
# dfOther = subset(dfTr, Category == "NA - Other") 
# dfTrig = subset(dfTr, Category == "Trigger") 
# dfUnCat = subset(dfTr, Category == "")
