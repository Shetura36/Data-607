---
title: "Data 607 Homework 5"
author: "Sherranette Tinapunan"
date: "March 4, 2018"
output: 
  html_document: 
    keep_md: yes
---



### Homework 5: Data Wrangling with tidyr and dplyr. 

### Load libraries

```r
library(dplyr)
library(tidyr)
library(knitr)
library(xtable)
```

### Step 1: Read airlines CSV file, and assign names to columns with no names.
>
* Column 1 --> name as "Airlines"
* Column 2 --> name as "Arrival.Status"
* The option na.strings = c("", "NA") is used in the read.table() to set blank data to 'NA'. 


```r
file_source = "https://raw.githubusercontent.com/Shetura36/Data-607-Assignments/master/Assignment5/Airlines.csv"

#results in data frame
airlines <- read.table(file_source, header=TRUE, sep=",", na.strings = c("", "NA"))

names(airlines)[1] <- "Airlines"
names(airlines)[2] <- "Arrival.Status"

#display data
kable(airlines)
```



Airlines   Arrival.Status    Los.Angeles   Phoenix   San.Diego   San.Francisco   Seattle
---------  ---------------  ------------  --------  ----------  --------------  --------
ALASKA     on time                   497       221         212             503      1841
NA         delayed                    62        12          20             102       305
NA         NA                         NA        NA          NA              NA        NA
AM WEST    on time                   694      4840         383             320       201
NA         delayed                   117       415          65             129        61

### Step 2: Remove blank rows.
> 
A blank row is identified as a row with "NA" for all the variables. 
 

```r
airlines <- airlines[!apply(is.na(airlines[1:7]),1,all), ]
row.names(airlines) <- NULL

# display. airlines does not have blank row anymore
kable(airlines)
```



Airlines   Arrival.Status    Los.Angeles   Phoenix   San.Diego   San.Francisco   Seattle
---------  ---------------  ------------  --------  ----------  --------------  --------
ALASKA     on time                   497       221         212             503      1841
NA         delayed                    62        12          20             102       305
AM WEST    on time                   694      4840         383             320       201
NA         delayed                   117       415          65             129        61

### Step 3: Assign an airline name to rows that have a blank airline name. 
> 
An <b>ASSUMPTION</b> is made here that every single row that has a blank airline name has <b>THE SAME</b> airline name to the row above it. In addition, this code <b>ASSUMES</b> that the <b>first row will always have a value for the airline name that is NOT 'NA'</b>. These assumptions are true for this specific file. This process would be the same if this file has 5 rows or more. 


```r
for(i in 2:nrow(airlines)) {
  
  if(is.na(airlines$Airlines[i])){
    airlines$Airlines[i] <- airlines$Airlines[i-1]
  }
}
#display
kable(airlines) 
```



Airlines   Arrival.Status    Los.Angeles   Phoenix   San.Diego   San.Francisco   Seattle
---------  ---------------  ------------  --------  ----------  --------------  --------
ALASKA     on time                   497       221         212             503      1841
ALASKA     delayed                    62        12          20             102       305
AM WEST    on time                   694      4840         383             320       201
AM WEST    delayed                   117       415          65             129        61

### Step 4: 'Gather' different city columns and transform them into cell values.
> 
* I will be using tidyr::gather() function
* Key-Value pair is going to be "City" and "Count" respectively.


```r
airlines_transform1 <- tidyr::gather(airlines, "City", "Count", 3:7)

#display
kable(airlines_transform1)
```



Airlines   Arrival.Status   City             Count
---------  ---------------  --------------  ------
ALASKA     on time          Los.Angeles        497
ALASKA     delayed          Los.Angeles         62
AM WEST    on time          Los.Angeles        694
AM WEST    delayed          Los.Angeles        117
ALASKA     on time          Phoenix            221
ALASKA     delayed          Phoenix             12
AM WEST    on time          Phoenix           4840
AM WEST    delayed          Phoenix            415
ALASKA     on time          San.Diego          212
ALASKA     delayed          San.Diego           20
AM WEST    on time          San.Diego          383
AM WEST    delayed          San.Diego           65
ALASKA     on time          San.Francisco      503
ALASKA     delayed          San.Francisco      102
AM WEST    on time          San.Francisco      320
AM WEST    delayed          San.Francisco      129
ALASKA     on time          Seattle           1841
ALASKA     delayed          Seattle            305
AM WEST    on time          Seattle            201
AM WEST    delayed          Seattle             61

### Step 5: 'Spread' <i>Arrival.Status</i> so that each distinct value becames a variable (column). 
> 
* I will be using tidyr::spread() function
* Key-Value pair is going to be "Arrival.Status" and "Count" respectively.
* The "Count" column was generated during Step 4. 


```r
airlines_transform2 <- tidyr::spread(airlines_transform1, Arrival.Status, Count)

#display
kable(airlines_transform2)
```



Airlines   City             delayed   on time
---------  --------------  --------  --------
ALASKA     Los.Angeles           62       497
ALASKA     Phoenix               12       221
ALASKA     San.Diego             20       212
ALASKA     San.Francisco        102       503
ALASKA     Seattle              305      1841
AM WEST    Los.Angeles          117       694
AM WEST    Phoenix              415      4840
AM WEST    San.Diego             65       383
AM WEST    San.Francisco        129       320
AM WEST    Seattle               61       201

### Step 6: Perform analysis to compare the arrival delays for the two airlines.
>
Display the max, min, average, standard deviation, median, and interquartile range of delays by Airlines. 
>
* I'm using dplyr::group_by() function to summarize data within each group. 


```r
delay_summary <- airlines_transform2 %>% dplyr::group_by(Airlines) %>% 
  dplyr::summarise(max=max(delayed), 
                   min=min(delayed),
                   avg=mean(delayed),
                   sd_delay=sd(delayed),
                   median=median(delayed),
                   IQR=IQR(delayed))
kable(delay_summary)
```



Airlines    max   min     avg   sd_delay   median   IQR
---------  ----  ----  ------  ---------  -------  ----
ALASKA      305    12   100.2   120.0175       62    82
AM WEST     415    61   157.4   147.1625      117    64
