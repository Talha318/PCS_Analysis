#Loading Raw data set

MasterData = read.csv("Raw Learning Data.csv" , header=TRUE)
RawData = MasterData


for 1 : length(levels(RawData$Category)) 
{    
  
SummaryStats[i] = summary(RawData$Category)[i] / 34233

  
}