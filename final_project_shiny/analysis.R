library("shiny")
library("dplyr")
library("tidyr")
library("jsonlite")
library("ggplot2")
library("hexbin")
library("rsconnect")
library('maps')


#-------import data----------------------

gini_raw_df <- read.csv("data/gini_index.csv")
freedom_raw_df <- read.csv("data/freedom_index.csv")
happiness_raw_df <- read.csv("data/happiness_index.csv")
world_raw_df <- map_data("world")


#--------/import data-----------------

View(gini_raw_df)
View(freedom_raw_df)
View(happiness_raw_df)
View(world_df)



#----------data prep-----------------------

gini_df <- gini_raw_df %>% 
  filter(Year == 2016) %>% 
  select(c(Country.Name,Value))

freedom_df <- freedom_raw_df %>% 
  rename(Country.Name = countries) %>% 
  select(c(Country.Name,hf_score))

happiness_df <- happiness_raw_df %>% 
  rename(Country.Name = Country) %>% 
  select(c(Country.Name,Happiness.Score)) 

world_df <- world_raw_df %>% 
  rename(Country.Name = region)
  
#----------/data prep----------------



#----------joining data------------
composite_df <- right_join(gini_df,freedom_df, by = "Country.Name")
composite_df <- left_join(composite_df, happiness_df, by = c("Country.Name"))

composite_map_df <- left_join(composite_df, world_df, by = "Country.Name")
View(composite_map_df)
#--------/joining data------------