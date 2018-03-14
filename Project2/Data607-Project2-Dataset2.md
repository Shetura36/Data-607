---
title: "Data 607 Project 2 - Dataset 2"
author: S. Tinapunan
date: "March 11, 2018"
output: 
  html_document: 
    keep_md: yes
---



### Gender Statistics Data from the World Bank Data Catalog

### About the dataset

https://datacatalog.worldbank.org/dataset/gender-statistics

The "Gender Statistics" dataset was taken from the World Bank data catalog.

This dataset has 631 different indicators, 263 distinct countries, and data that span from 1960 to 2017. Visually reviewing the file, I noticed that available data is somewhat sparse. 

### Analysis goals

This analysis will investigate the indicator `Married women are required by law to obey their husbands (1=yes; 0=no)` under indicator code `SG.LAW.OBHB.MR`.

#### Questions

This analysis will attempt to answer these questions: 

1) How many countries require married women to obey their husbands by law? 

2) Which are the countries that require married women to obey their husbands by law?

3) What's the trend in the number of countries that require married women to obey their husbands by law? 



### Findings 

There are 19 countries that are positive for the indicator `SG.LAW.OBHB.MR` (Married women are required by law to obey their husbands (1=yes; 0=no)) within the years 2009, 2011, 2013, and 2015.

Overall, there appears to be a consistent trend in the number of countries with laws requiring married women to obey their husbands from 2009 to 2015. 

For the last 7 countries that have values of NA for the years 2009, 2011 and 2013, no data was collected and reported (see table below). As a result, we cannot tell if the 2015 laws were new or not. 

The table below does not have any data that suggests that there are countries that once tested positive for this indicator but later on tested negative or vice versa. 


|country_name         | X2009| X2011| X2013| X2015| indicator_sum|
|:--------------------|-----:|-----:|-----:|-----:|-------------:|
|Congo, Dem. Rep.     |     1|     1|     1|     1|             4|
|Egypt, Arab Rep.     |     1|     1|     1|     1|             4|
|Gabon                |     1|     1|     1|     1|             4|
|Iran, Islamic Rep.   |     1|     1|     1|     1|             4|
|Jordan               |     1|     1|     1|     1|             4|
|Malaysia             |     1|     1|     1|     1|             4|
|Mali                 |     1|     1|     1|     1|             4|
|Saudi Arabia         |     1|     1|     1|     1|             4|
|Sudan                |     1|     1|     1|     1|             4|
|United Arab Emirates |     1|     1|     1|     1|             4|
|West Bank and Gaza   |     1|     1|     1|     1|             4|
|Yemen, Rep.          |     1|     1|     1|     1|             4|
|Afghanistan          |    NA|    NA|    NA|     1|             1|
|Bahrain              |    NA|    NA|    NA|     1|             1|
|Brunei Darussalam    |    NA|    NA|    NA|     1|             1|
|Djibouti             |    NA|    NA|    NA|     1|             1|
|Equatorial Guinea    |    NA|    NA|    NA|     1|             1|
|Iraq                 |    NA|    NA|    NA|     1|             1|
|Qatar                |    NA|    NA|    NA|     1|             1|


### Load libraries

```r
rm(list=ls())

library(dplyr)
library(tidyr)
library(knitr)
library(ggplot2)
library(stringr)
library(DT)
```


### Step 1: Load dataset

There is an extra column that is blank that gets read as a column because every row of the source file ends in a comma. This blank column by default is assigned the name "X". I am going to drop this column. 


```r
fileSource = "https://raw.githubusercontent.com/Shetura36/Data-607-Assignments/master/Project2/Gender_StatsData.csv"

data = read.table(fileSource, header=TRUE, sep=",", na.strings = c("", "NA"))
data$X <- NULL
```

### Step 2: Rename some columns and preview dataset

This file has 165,953 observations and 62 variables. 

Below is a preview of the dataset. This only includes the first 7 columns. 


```r
names(data)[1] <- "country_name"
names(data)[2] <- "country_code"
names(data)[3] <- "indicator_name"
names(data)[4] <- "indicator_code"

#Count of distinct country names
data %>% dplyr::select(country_name) %>% dplyr::n_distinct()
```

```
## [1] 263
```

```r
kable(data[346:356,1:7], format="markdown")
```



|    |country_name |country_code |indicator_name                            |indicator_code    |        X1960|        X1961|        X1962|
|:---|:------------|:------------|:-----------------------------------------|:-----------------|------------:|------------:|------------:|
|346 |Arab World   |ARB          |Population ages 0-14 (% of total)         |SP.POP.0014.TO.ZS | 4.331695e+01| 4.368345e+01| 4.400712e+01|
|347 |Arab World   |ARB          |Population ages 0-14, female              |SP.POP.0014.FE.IN | 1.958952e+07| 2.029782e+07| 2.101818e+07|
|348 |Arab World   |ARB          |Population ages 15-64 (% of total)        |SP.POP.1564.TO.ZS | 5.317222e+01| 5.277319e+01| 5.242335e+01|
|349 |Arab World   |ARB          |Population ages 15-64, female             |SP.POP.1564.FE.IN | 2.457025e+07| 2.506054e+07| 2.558162e+07|
|350 |Arab World   |ARB          |Population ages 15-64, male               |SP.POP.1564.MA.IN | 2.460924e+07| 2.509760e+07| 2.562692e+07|
|351 |Arab World   |ARB          |Population ages 15-64, total              |SP.POP.1564.TO    | 4.917948e+07| 5.015802e+07| 5.120833e+07|
|352 |Arab World   |ARB          |Population ages 65 and above (% of total) |SP.POP.65UP.TO.ZS | 3.510826e+00| 3.543357e+00| 3.569528e+00|
|353 |Arab World   |ARB          |Population ages 65 and above, female      |SP.POP.65UP.FE.IN | 1.749772e+06| 1.816132e+06| 1.883087e+06|
|354 |Arab World   |ARB          |Population, female                        |SP.POP.TOTL.FE.IN | 4.590955e+07| 4.717449e+07| 4.848289e+07|
|355 |Arab World   |ARB          |Population, female (% of total)           |SP.POP.TOTL.FE.ZS | 4.963681e+01| 4.963411e+01| 4.963324e+01|
|356 |Arab World   |ARB          |Population, total                         |SP.POP.TOTL       | 9.249093e+07| 9.504450e+07| 9.768229e+07|

### Step 3: Create a subset for indicator `Married women are required by law to obey their husbands (1=yes; 0=no)` under code `SG.LAW.OBHB.MR`

In this analysis, I will only focus on this particular indicator. So there is no need to include the other indicators when I'm doing my data transformation and analysis. 

There are 263 observations with indicator code `SG.LAW.OBHB.MR`. This matches the number of distinct country names in the data set. The code below removes any year columns that do not have any values other than NA across all observations. These are years that data for this indicator was not collected/reported across all countries. And then, remove all observations that do not have data for this indicator across all year columns that have at least 1 value for this indicator. 

Reviewing the subset, this indicator was first recorded in 2009, and appears to be updated every two years. We find this indicator to be reported in the years 2009, 2011, 2013, and 2015. This indicator was at least collected once within these 4 years in 188 countries. 

Below you will see a preview of the first few rows of the target subset.


```r
#filter only for this specific indicator
target <- data %>% dplyr::filter(data$indicator_code == "SG.LAW.OBHB.MR")

# columns 5 through 62 are year columns
# We are removing year columns that do not have any values for this indicator
# The code below collects all column indices for years that do not have data. 
# We will use this list of column indices to remove those columns. 
# c vector initializes with zero
c <- vector(mode="numeric", length=ncol(target)-5)
for(i in 5:ncol(target)){
  if(all(is.na(target[,i]))){
    c[i-5+1] <- i
  }
}
# we will keep indices that are greater than zero
c <- c[c > 0]

# drop year columns that do not have data for this indicator
target <- target[-c]

# 263 observations and 8 variables after removing year columns with no data accross all observations
dim(target)
```

```
## [1] 263   8
```

```r
# drop all observations with no data across all year columns that have at least 1 data. 
target <- target[!apply(is.na(target[,5:8]), 1, all) ,]

# final subset: 188 observations remaining with 8 variables 
dim(target)
```

```
## [1] 188   8
```

```r
# remove row names
rownames(target) <- c()

kable(head(target[,c(1,4, 5:8)],10), format="markdown")
```



|country_name        |indicator_code | X2009| X2011| X2013| X2015|
|:-------------------|:--------------|-----:|-----:|-----:|-----:|
|Afghanistan         |SG.LAW.OBHB.MR |    NA|    NA|    NA|     1|
|Albania             |SG.LAW.OBHB.MR |     0|     0|     0|     0|
|Algeria             |SG.LAW.OBHB.MR |     0|     0|     0|     0|
|Angola              |SG.LAW.OBHB.MR |     0|     0|     0|     0|
|Antigua and Barbuda |SG.LAW.OBHB.MR |    NA|    NA|    NA|     0|
|Argentina           |SG.LAW.OBHB.MR |     0|     0|     0|     0|
|Armenia             |SG.LAW.OBHB.MR |     0|     0|     0|     0|
|Australia           |SG.LAW.OBHB.MR |     0|     0|     0|     0|
|Austria             |SG.LAW.OBHB.MR |     0|     0|     0|     0|
|Azerbaijan          |SG.LAW.OBHB.MR |     0|     0|     0|     0|

### Step 4: Transform subset

This subset has the columns country_name, country_code, indicator_name, indicator_code, and column years for 2009, 2011, 2013, and 2015. 

I am going to use tidyr to transform all the year columns into a single year column so that every observation will have the columns country_name, country_code, indicator_name, indicator_code, and year. The column names of each "year" column will become values on the new `year` column. 

The `tidyr::gather` function will accomplish this. 

As a result of this transformation, I no longer need 2 columns: `indicator_name`, and `indicator_code`. I am going to drop these 2 columns from the data frame. 

The code below also removes the "X" in front of the year once the data has been transformed. 

Below you will see a preview of the first few rows of the transformed subset.


```r
target_wide <- target
target <- tidyr::gather(target, "year", "obeyHusband_SG.LAW.OBHB.MR", 5:8)

target$indicator_code <- NULL
target$indicator_name <- NULL

for (i in 1:nrow(target)) {
  target[i,3] <- stringr::str_extract(target[i,3], "[0-9]{4,4}")
}

kable(head(target, 10), format="markdown")
```



|country_name        |country_code |year | obeyHusband_SG.LAW.OBHB.MR|
|:-------------------|:------------|:----|--------------------------:|
|Afghanistan         |AFG          |2009 |                         NA|
|Albania             |ALB          |2009 |                          0|
|Algeria             |DZA          |2009 |                          0|
|Angola              |AGO          |2009 |                          0|
|Antigua and Barbuda |ATG          |2009 |                         NA|
|Argentina           |ARG          |2009 |                          0|
|Armenia             |ARM          |2009 |                          0|
|Australia           |AUS          |2009 |                          0|
|Austria             |AUT          |2009 |                          0|
|Azerbaijan          |AZE          |2009 |                          0|

### Step 5: Calculate summary data

The subset only includes countries that have at least one reported value for the indicator for the years 2009, 2011, 2013, and 2015. The indicator `SG.LAW.OBHB.MR` (countries with laws that require married women to obey their husbands) is reported as either `0` (no) or `1` (yes). 

I'm going to create a new column that will store the sum of the values reported for the indicator for the 4 years. The idea here is if the `sum > 0`, then the country is positive for this indicator at least once within the 4 years when data was reported. This will give us a list of all countries that at one point from 2009 to 2015 had or have laws that require married women to obey their husbands. 

In addition, to visualize the trend better in a table format, the wide format version of the data is more suitable for this purpose. To do this, I joined the wide format data with the list of countries that are positive for the indicator. 


```r
indicatorSum_byCountry <-
  data.frame(target %>% 
    dplyr::group_by(country_name) %>%  
    dplyr::summarise(indicator_sum = sum(obeyHusband_SG.LAW.OBHB.MR, na.rm = TRUE)))

indicatorPositive_byCountry <- 
indicatorSum_byCountry %>% dplyr::arrange(desc(indicator_sum)) %>% 
  dplyr::filter(indicator_sum > 0)

indicatorPositive_byCountry_Display <-
dplyr::inner_join(target_wide, indicatorPositive_byCountry, "country_name") %>%   
        dplyr::select(country_name, X2009, X2011, X2013, X2015, indicator_sum) %>% 
        arrange(desc(indicator_sum))
```

### Step 6: Answer questions

#### 1) How many countries require married women to obey their husbands by law? 

There are 19 countries that are positive for this indicator (`SG.LAW.OBHB.MR`). The list of countries below had or have law that require married women to obey their husbands within the years 2009, 2011, 2013, and 2015. 


```r
# number of countries: 
indicatorPositive_byCountry %>% dplyr::summarise(n())
```

```
##   n()
## 1  19
```


#### 2) Which are the countries that require married women to obey their husbands by law? 

Below are the 19 countries that had or have laws that require married women to obey their husbands within the years 2009, 2011, 2013, and 2015. 


```r
kable(indicatorPositive_byCountry, format="markdown")
```



|country_name         | indicator_sum|
|:--------------------|-------------:|
|Congo, Dem. Rep.     |             4|
|Egypt, Arab Rep.     |             4|
|Gabon                |             4|
|Iran, Islamic Rep.   |             4|
|Jordan               |             4|
|Malaysia             |             4|
|Mali                 |             4|
|Saudi Arabia         |             4|
|Sudan                |             4|
|United Arab Emirates |             4|
|West Bank and Gaza   |             4|
|Yemen, Rep.          |             4|
|Afghanistan          |             1|
|Bahrain              |             1|
|Brunei Darussalam    |             1|
|Djibouti             |             1|
|Equatorial Guinea    |             1|
|Iraq                 |             1|
|Qatar                |             1|

#### 3) What's the trend in the number of countries that require married women to obey their husbands by law? 

Overall, there appears to be a consistent trend in the number of countries with laws requiring married women to obey their husbands from 2009 to 2015. 

For the last 7 countries that have values of NA for the years 2009, 2011 and 2013, no data was reported (see table below). As a result, we cannot tell if the 2015 laws were new or not. 

The table below does not have any data that suggests that there are countries that once tested positive for this indicator but later on tested negative or vice versa. 


```r
kable(indicatorPositive_byCountry_Display, format="markdown")
```



|country_name         | X2009| X2011| X2013| X2015| indicator_sum|
|:--------------------|-----:|-----:|-----:|-----:|-------------:|
|Congo, Dem. Rep.     |     1|     1|     1|     1|             4|
|Egypt, Arab Rep.     |     1|     1|     1|     1|             4|
|Gabon                |     1|     1|     1|     1|             4|
|Iran, Islamic Rep.   |     1|     1|     1|     1|             4|
|Jordan               |     1|     1|     1|     1|             4|
|Malaysia             |     1|     1|     1|     1|             4|
|Mali                 |     1|     1|     1|     1|             4|
|Saudi Arabia         |     1|     1|     1|     1|             4|
|Sudan                |     1|     1|     1|     1|             4|
|United Arab Emirates |     1|     1|     1|     1|             4|
|West Bank and Gaza   |     1|     1|     1|     1|             4|
|Yemen, Rep.          |     1|     1|     1|     1|             4|
|Afghanistan          |    NA|    NA|    NA|     1|             1|
|Bahrain              |    NA|    NA|    NA|     1|             1|
|Brunei Darussalam    |    NA|    NA|    NA|     1|             1|
|Djibouti             |    NA|    NA|    NA|     1|             1|
|Equatorial Guinea    |    NA|    NA|    NA|     1|             1|
|Iraq                 |    NA|    NA|    NA|     1|             1|
|Qatar                |    NA|    NA|    NA|     1|             1|

