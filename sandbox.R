library(tidyverse)
library(ggplot2)
library(plotly)
data = read.csv('edge1.1.csv')

head(data,2)

# Select variables wanted for initial analysis / regression
# "Participated" is created because every entry in the initial data frame is considered to have participated in the conversationh
df = data %>% 
  select(ThreadId,Id_num,Male,Female,FemaleParticipation) %>%
  mutate(participated = 1)

#Create a unique ID in order to bring IDs of Thread and User together
df$new.id = paste(df$Id_num,df$ThreadId,sep='-')


####################################################################################################

#### This portion needs massive amounts of help - slow but works ####
# Creating a dataframe which iterates through and associates a Thread ID with Every single User ID
# This will be used to merge in order to associate zeros for "participated"
###

#Create lists of uniques in order to iterate through 
u.Id_num = unique(df$Id_num)
u.ThreadId = unique(df$ThreadId)

a = data.frame(x=0,y=0)
b = data.frame(x=0,y=0)
for(j in 1:length(u.ThreadId)){
  b = rbind(b,a)
  a = data.frame(x=0,y=0)
  for(i in 1:length(u.Id_num)){
    a[i,1] = u.Id_num[i]
    a[i,2] = u.ThreadId[j]
  }
}

c = b[3:nrow(b),]
c$new.id = paste(c$x,c$y,sep='-')
d = merge(df,c,by='new.id',all=TRUE)
d[is.na(d)] = 0

####################################################################################################

# Creating the "final data frame" which has
final.df = d %>% 
  mutate(PARTICIPATION.CALCULATION = Female * participated * FemaleParticipation) %>%
  select(ThreadId,Id_num,Male,Female,FemaleParticipation,PARTICIPATION.CALCULATION)
