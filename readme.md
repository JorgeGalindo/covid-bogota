# Bogotá's COVID-19 epidemic evolution

This is just an ongoing personal R project aimed to extract and work with official COVID-19 infection data provided by the city of Bogotá (Colombia). The city uploaded a series of .csv files on the 8th of April 2020. The project will go on as long as I have access to the data, and/or as long as the epidemic outbreak lasts.

Today (ie. last update) = 9 April 2020

## What you need

As of today, to run this you just need R and a couple basic libraries (Tidyverse, lubridate).

## What's in

You'll see a couple folders: scripts and data_output. They contain what they seem to contain (scripts to obtain the data, and the resulting output).

**Basic_extract.R** simply extracts the individual anonimized data provided by the city of Bogotá and produces a standard tidy dataframe with cases and deaths in each localidad (Bogotá is administratively subdivided into localidades, a Spanish word that roughly translates to neighbourhood).
**daily_statustracker.R** is a bit more exciting. It extracts the individual anonimized data provided by the city of Bogotá and produces a .csv file called **cases_dailystatus.csv**. If you run the script every day at the same time (I would advice something like 8-9PM EST, since Bogotá updates the file around 1-4PM local time), the .csv will accumulate the daily status (mild, moderate, severe case, death) and location (home, hospital, hospital ICU, dead) of each case, **assuming that the originally downloaded .csv keeps an untouched case order**. So far it has done so. I will keep an eye on that.

Categories are in Spanish so far. I might add some code to translate them in the future.

## What will be in (hopefully)

Bogotá is providing data on hospital/ICU occupation rates as well. I plan to build a daily tracker for that in the coming hours :)

## Author

Jorge Galindo

[@JorgeGalindo](https://twitter.com/jorgegalindo)


## License

Free to use however you see fit! But I wish you will read some epidemiological specialized literature before getting too excited about trends, etc. I'm no epidemiologist myself, that's why I dare advising it. I hope you can provide something useful to the public debate. I'm sure you will :)