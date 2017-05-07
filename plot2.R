## download the data and unzip it
if(!file.exists("./1plotdata")) {dir.create("./1plotdata")}
temp <- tempfile()
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = temp)
unzip(temp, exdir = "./1plotdata")
unlink(temp)
setwd("./1plotdata")


## read data into R
power <- read.table(file = "household_power_consumption.txt",
                    header = TRUE,
                    sep = ";", 
                    na.strings = "?")

## change "Date" column to the Date class
power$Date <- as.Date(power$Date, format = "%d/%m/%Y")

## use dplyr functions to get only the data that you need
## also, combine "Date" and "Time" columns into one column called "datetime"
library(dplyr)
power <- filter(power, Date == "2007-02-01" | Date == "2007-02-02") 
power <- mutate(power, datetime = paste(power$Date, power$Time, sep = " ")) %>% 
        select(datetime, Global_active_power:Sub_metering_3)

## convert datetime to POSIXct
power$datetime <- as.POSIXct(power$datetime)

## plot
png(file = "plot2.png", width = 480, height = 480)
with(power, plot(datetime, Global_active_power, type = "l", xlab = "", 
                 ylab = "Global Active Power (kilowatts)"))

dev.off()

