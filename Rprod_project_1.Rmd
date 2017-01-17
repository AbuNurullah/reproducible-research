---
title: "project-1.Rmd"
author: "Abu Nurullah"
date: "January 16, 2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

#Analyzing FitBit Data

Abu M. Nurullah

##About
This is the first project under the course "Reproducible Research".  
The bjective of this exercise is to process a dataset collected 
from a FirBit device and answer a series of questions with regards to
the data provided.

##Data
The data is to be read from the following location on the course web site
https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip

Dataset: Activity monitoring data [52K]

The dataset is stored in a comma-separated-value (CSV) file containing a
total of 17,568 observations. Variables included in this dataset are:

 steps: Number of steps taking in a 5-minute interval (missing values are coded as   NA)
 
 date: The date on which the measurement was taken in YYYY-MM-DD format
 
 interval: Identifier for the 5-minute interval in which measurement was taken


##Loading and preprocessing the data.......

Download, unzip and load data into a data frame data.

```{r data,Echo = TRUE}
if(!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")) {
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip",temp)
        
unzip(temp)
unlink(temp)

}

data <- read.csv("activity.csv")
```
##What is mean total number of steps taken per day?

-Calculate the total number of steps taken per day

-Make a histogram of the total number of steps taken each day

-Calculate and report the mean and median of the total number of steps taken per day


```{r , Echo = TRUE}
steps_by_day <- aggregate(steps ~ date, data = data, FUN = sum, na.rm = TRUE)

hist(steps_by_day$steps, main = paste("Total Steps Each Day"), col="Red", xlab="Number of Steps")
```

##What is the average daily activity pattern?

-Calculate and report the mean and median of the total number of steps taken per day

```{r mean steps, Echo = TRUE}
mean_steps_per_day = mean(steps_by_day$steps)
median_steps_per_day = median(steps_by_day$steps)
```
Mean of total steps taken by day: `r mean_steps_per_day` and median of total steps
taken per day `r median_steps_per_day`

##What is the average daily activity pattern?

-Calculate average steps for each interval for all days.

-Plot the Average Number Steps per Day by Interval.
-Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) 
 and the average number of steps taken, averaged across all days (y-axis)

-Find out which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?


```{r }
steps_by_interval <- aggregate(steps ~ interval, data = data, FUN = mean)

plot(steps_by_interval$interval,steps_by_interval$steps, type="l", xlab="Interval", ylab="Number of Steps",main="Average Number of Steps per Day by Interval")

most_steps_interval <- steps_by_interval[which.max(steps_by_interval$step), 1]
```

The 5-min interval with the most steps is: `r most_steps_interval`

#Inputing missing values
-Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

-Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

-Create a new dataset that is equal to the original dataset but with the missing data filled in.

-Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. 

-Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

```{r }

missing_values_count = sum(!complete.cases(data))

```
The number of rows with missing value in the data: `r missing_values_count`

```{r inputed data}
imputed_data <- transform(data, steps = ifelse(is.na(data$steps), steps_by_interval$steps[match(data$interval, steps_by_interval$interval)], data$steps))
```
The NA values are replaced with 0
imputed_data[is.na(imputed_data$steps)] <- 0

Making histogram with the newly inputed dataset

```{r inputed data histogram}
steps_by_day_i <- aggregate(steps ~ date, imputed_data, sum)
hist(steps_by_day_i$steps, main = paste("Total Steps Each Day"), col="blue", xlab="Number of Steps")

#Create Histogram to show difference. 
hist(steps_by_day$steps, main = paste("Total Steps Each Day"), col="red", xlab="Number of Steps", add=T)
legend("topright", c("Imputed", "Non-imputed"), col=c("blue", "red"), lwd=10)

```

Calculate new mean and median for the inputed data

```{r inputed data mean, median}

mean_steps_per_day_i = mean(steps_by_day_i$steps)
median_steps_per_day_i = median(steps_by_day_i$steps)
```

The mean steps per day for the inputed datasets is `r mean_steps_per_day_i` and the median steps is `r median_steps_per_day_i` 

Difference between mean and median of both original and inputed datasets
```{r}
mean_diff <- mean_steps_per_day_i - mean_steps_per_day
median_diff <- median_steps_per_day_i  - median_steps_per_day
total_diff <- sum(steps_by_day_i$steps) - sum(steps_by_day$steps)

```

-The imputed data mean is `r mean_steps_per_day_i`

-The imputed data median is `r median_steps_per_day_i`

-The difference between origianl and imputed mean is `r mean_diff`

-The difference between original and imputed median is `r median_diff`

-The difference between total number of steps between imputed and original data is `r total_diff`


##Activity difference between weekday and weekends
```{r}
weekdays <- c("Monday", "Tuesday", "Wednesday", "Thursday", 
              "Friday")
imputed_data$dow = as.factor(ifelse(is.element(weekdays(as.Date(imputed_data$date)),weekdays), "Weekday", "Weekend"))

steps_by_interval_i <- aggregate(steps ~ interval + dow, imputed_data, mean)

library(lattice)

xyplot(steps_by_interval_i$steps ~ steps_by_interval_i$interval|steps_by_interval_i$dow, main="Average Steps per Day by Interval",xlab="Interval", ylab="Steps",layout=c(1,2), type="l")

```

It is observed that there is a higher peak earlier on weekdays, and more overall activity on weekends.
