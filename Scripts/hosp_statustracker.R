#Extracting, cleaning and producing a useful daily tracker of the occupancy levels in Bogotá's hospital system
#Note that...
#"general" means "general/standard hospitalization"; 
#"UMI" stands for "Intermediate Care Unit" by its Spanish acronym; 
#"UCI" stands for "Intensive Care Unit" by its Spanish acronym

#Author: Jorge Galindo

rm(list = ls())
library(tidyverse)
library(lubridate)


#1. Scrap and add ID

hosp_daily_public_df <- read.csv("http://saludata.saludcapital.gov.co/osb/datos_abiertos_osb/oferta-servicios/OSB_OfertaSrv-ocupacioncamas.csv", sep =";", skip = 6, col.names=c("cat", "public_general_neonatal","public_general_pediatric","public_general_adult","public_UMI_neonatal","public_UMI_pediatric","public_UMI_adult","public_UCI_neonatal","public_UCI_pediatric","public_UCI_adult"), fileEncoding="Windows-1252")

id_publ <- rownames(hosp_daily_public_df)
hosp_daily_public_df <- cbind(id_publ=as.numeric(id_publ), hosp_daily_public_df)

hosp_daily_private_df <- read.csv("http://saludata.saludcapital.gov.co/osb/datos_abiertos_osb/oferta-servicios/OSB_OfertaSrv-ocupacioncamas.csv", sep =";", skip = 14, col.names=c("cat", "private_general_neonatal","private_general_pediatric","private_general_adult","private_UMI_neonatal","private_UMI_pediatric","private_UMI_adult","private_UCI_neonatal","private_UCI_pediatric","private_UCI_adult"), fileEncoding="Windows-1252")

id_priv <- rownames(hosp_daily_private_df)
hosp_daily_private_df <- cbind(id_priv=as.numeric(id_priv), hosp_daily_private_df)

#2. The BIG cleanup

hosp_daily_public_all_longer_df <- hosp_daily_public_df %>%
  filter(id_publ<3) %>%
  select(-id_publ) %>%
  filter(cat=="Camas habilitadas") %>%
  pivot_longer(c("cat", "public_general_neonatal","public_general_pediatric","public_general_adult","public_UMI_neonatal","public_UMI_pediatric","public_UMI_adult","public_UCI_neonatal","public_UCI_pediatric","public_UCI_adult"), names_to = "bedtype", values_to="total") %>%
  filter(bedtype!="cat")

hosp_daily_public_occupied_longer_df <- hosp_daily_public_df %>%
  filter(id_publ<3) %>%
  select(-id_publ) %>%
  filter(cat=="Camas ocupadas") %>%
  pivot_longer(c("cat", "public_general_neonatal","public_general_pediatric","public_general_adult","public_UMI_neonatal","public_UMI_pediatric","public_UMI_adult","public_UCI_neonatal","public_UCI_pediatric","public_UCI_adult"), names_to = "bedtype", values_to="occupied") %>%
  filter(bedtype!="cat")

hosp_daily_public_df <- left_join(hosp_daily_public_all_longer_df,hosp_daily_public_occupied_longer_df)

hosp_daily_private_all_longer_df <- hosp_daily_private_df %>%
  filter(id_priv<3) %>%
  select(-id_priv) %>%
  filter(cat=="Camas habilitadas") %>%
  pivot_longer(c("cat", "private_general_neonatal","private_general_pediatric","private_general_adult","private_UMI_neonatal","private_UMI_pediatric","private_UMI_adult","private_UCI_neonatal","private_UCI_pediatric","private_UCI_adult"), names_to = "bedtype", values_to="total") %>%
  filter(bedtype!="cat")

hosp_daily_private_occupied_longer_df <- hosp_daily_private_df %>%
  filter(id_priv<3) %>%
  select(-id_priv) %>%
  filter(cat=="Camas ocupadas") %>%
  pivot_longer(c("cat", "private_general_neonatal","private_general_pediatric","private_general_adult","private_UMI_neonatal","private_UMI_pediatric","private_UMI_adult","private_UCI_neonatal","private_UCI_pediatric","private_UCI_adult"), names_to = "bedtype", values_to="occupied") %>%
  filter(bedtype!="cat")

#3. Joining the data, tagging the date and creating clear  categories

hosp_daily_private_df <- left_join(hosp_daily_private_all_longer_df,hosp_daily_private_occupied_longer_df)

hosp_daily_df <- rbind(hosp_daily_private_df, hosp_daily_public_df)

hosp_daily_df <- hosp_daily_df %>%
  separate(bedtype, sep = "_", into = c("ownership","care","population")) %>%
  mutate(
        total=as.character(total),
        occupied=as.character(occupied)
        ) %>%
  mutate(
        total=gsub("[.]","", total),
        occupied=gsub("[.]","", occupied)
        ) %>%
  mutate(status_date=today(),
         total=as.numeric(total),
         occupied=as.numeric(occupied)
         )

## Saving the output -- the append = TRUE part is crucial! Just change the path if you wish. 
write.table(hosp_daily_df, "/Users/jorgegalindo/Desktop/projects/covid-Bogota/data_output/hosp_dailystatus.csv", sep = ",", append = TRUE, quote = FALSE,
            col.names = TRUE, row.names = FALSE, fileEncoding = "UTF-8")
