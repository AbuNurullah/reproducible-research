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

The Rmarkdown file contains the code
