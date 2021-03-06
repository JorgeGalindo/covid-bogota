#Extracting, cleaning and producing a useful daily tracker of the health status of Bogotá's daily COVID infections
#Author: Jorge Galindo

rm(list = ls())
setwd(here::here())
library(tidyverse)
library(lubridate)

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
         status=str_replace_all(status, c("Leve"="Mild","Moderado"="Moderate", "Severo"="Severe", "Grave"="Critical", "GRAVE"="Critical", "Crítico"="Critical", "Fallecido"="Dead"))
                )

#2. Produce a daily updated csv file storing the evolving status of all individual patients 
#(necessary assumption: original table does not change the order of patients)

single_daily_df <- individual_daily_df %>%
  select(id, place, status) %>%
  mutate(status_date=today())


## Saving the output -- the append = TRUE part is crucial! Just edit the path.
write.table(single_daily_df, "data_output/cases_dailystatus.csv", sep = ",", append = TRUE, quote = FALSE,
            col.names = FALSE, row.names = FALSE)

#-------# If you run the script once daily up to here, you will get your CSV with daily updates. 
#-------# My advice: run it in the evening (Bogotá/EST time). You may also want to consider automating the process with CRON.
