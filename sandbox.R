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

all.ids = data.frame(Id_num_n = rep(u.Id_num,length(u.ThreadId)), ThreadId_n = rep(u.ThreadId,length(u.Id_num)))
all.ids$new.id = paste(all.ids$Id_num_n,all.ids$ThreadId_n,sep='-')

full.thread.data = merge(df,all.ids,by='new.id',all=TRUE)
full.thread.data[is.na(full.thread.data)] = 0

####################################################################################################

# Creating the "final data frame" which has
final.df = full.thread.data %>% 
  mutate(PARTICIPATION.CALCULATION = Female * participated * FemaleParticipation) %>%
  select(ThreadId,Id_num,Male,Female,FemaleParticipation,PARTICIPATION.CALCULATION)
