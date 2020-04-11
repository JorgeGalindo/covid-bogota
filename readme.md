# Bogotá's COVID-19 epidemic evolution

This is just an ongoing personal R project aimed to extract and work with official COVID-19 infection data provided by the city of Bogotá (Colombia). The city uploaded a series of .csv files on the 8th of April 2020. The project will go on as long as I have access to the data, and/or as long as the epidemic outbreak lasts.

Today (ie. last update) = 10 April 2020

## What you need

As of today, to run this you just need R and a couple basic libraries (Tidyverse, lubridate).

## What's in

You'll see a couple folders: scripts and data_output. They contain what they seem to contain (scripts to obtain the data, and the resulting output).

**Basic_extract.R** simply extracts the individual anonimized data provided by the city of Bogotá and produces a standard tidy dataframe with cases and deaths in each localidad (Bogotá is administratively subdivided into localidades, a Spanish word that roughly translates to neighbourhood).
**daily_statustracker.R** is a bit more exciting. It extracts the individual anonimized data provided by the city of Bogotá and produces a .csv file called **cases_dailystatus.csv**. If you run the script every day at the same time (I would advice something like 8-9PM EST, since Bogotá updates the file around 1-4PM local time), the .csv will accumulate the daily status (mild, moderate, severe case, death) and location (home, hospital, hospital ICU, dead) of each case, **assuming that the originally downloaded .csv keeps an untouched case order**. So far it has done so. I will keep an eye on that.


**Hosp_statustracker.R** takes advantage of the fact that Bogotá is providing data on hospital/ICU occupation rates as well. If you run it daily, the .csv will accumulate daily data on how many available beds are there in the city, classified by ownership of the hospital, type of care provided, and target population. The .csv **hosp_dailystatus.csv** keeps the data. Again, for daily runs I would advice something like 8-9PM EST, since Bogotá updates the file around 1-4PM local time.

I do keep the .csv documents daily updated, starting 8 April 2020.


## What will be in (hopefully)


Among other things I plan to find out how to add some code to schedule a daily download and update of the .csv files. Any advice will be more than welcome!


## Author

Jorge Galindo - [@JorgeGalindo](https://twitter.com/jorgegalindo)


## License

Free to use however you see fit! But I wish you read some specialized literature before getting too excited about trends, etc. I'm no epidemiologist myself, that's why I know you'll need it in case you are neither. I hope you can provide something useful to the public debate. I'm sure you will :)