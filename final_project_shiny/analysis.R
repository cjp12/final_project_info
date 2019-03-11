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

#View(gini_raw_df)
#View(freedom_raw_df)
#View(happiness_raw_df)
#View(world_df)



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


composite_df <- left_join(world_df, freedom_df, by = "Country.Name")
composite_map_df <- left_join(composite_df, happiness_df, by = c("Country.Name"))

View(composite_df)
View(composite_map_df)
#--------/joining data------------









composite_map_sliced_df <- composite_map_df %>% 
  mutate(
    total_score = (hf_score * 50) + (Happiness.Score * 50)
  ) %>% 
  arrange(desc(total_score)) %>% 
  select(c(Country.Name)) %>%
  unique() %>% 
  View()
