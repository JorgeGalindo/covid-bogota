#Extracting, cleaning and producing a basic set of dataframe from Bogotá's official data on covid infections
#Author: Jorge Galindo

rm(list = ls())
library(tidyverse)
setwd(here::here())

#1. Scrap and clean up a bit
individual_daily_df <- read.csv("https://datosabiertos.bogota.gov.co/dataset/44eacdb7-a535-45ed-be03-16dbbea6f6da/resource/b64ba3c4-9e41-41b8-b3fd-2da21d627558/download/osb_enftransm-covid-19.csv", sep =",", col.names=c("detect_date","city","localidad","age","sex","type","place","status"), fileEncoding="Windows-1252")

id <- rownames(individual_daily_df)
individual_daily_df <- cbind(id=id, individual_daily_df)

individual_daily_df <- individual_daily_df %>% 
  mutate(detect_date=as.Date(detect_date,format="%d/%m/%Y")) %>%
  separate(localidad, sep = " - ", into = c("loc_code", "loc_name"))


##Translate
individual_daily_df <- individual_daily_df  %>% 
  mutate(place=str_replace_all(place, c("Casa"="Home","Hospital UCI"="ICU", "Fallecido"="Dead")),
         status=str_replace_all(status, c("Leve"="Mild","Moderado"="Moderate", "Grave"="Critical", "GRAVE"="Critical","Fallecido"="Dead"))
  )

#2. Produce basic tidy dataframe, with daily and cumulative cases

basic_df <- individual_daily_df %>% 
  mutate(dead = if_else(status == "Dead", "new_deaths" , "new_cases")) %>%
  select(detect_date, loc_name, dead) %>%
  group_by(detect_date, loc_name, dead) %>%
  count()  %>%
  pivot_wider(names_from=dead, values_from=n) %>%
  mutate(new_deaths = replace_na(new_deaths, 0)) %>%
  mutate(new_cases = replace_na(new_cases, 0)) %>%
  group_by(loc_name)  %>%
  mutate(
    cum_deaths = cumsum(new_deaths),
    cum_cases = cumsum(new_cases)
  )