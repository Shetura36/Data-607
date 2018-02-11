---
title: "Data607 - Week 2"
author: "Sherranette Tinapunan"
date: "February 11, 2018"
output: 
  html_document: 
    keep_md: yes
---



### Homework 2

>Choose six recent popular movies.  Ask at least five people that you know (friends, family, classmates, imaginary friends) to rate each of these movie that they have seen on a scale of 1 to 5.  Take the results (observations) and store them in a SQL database.  Load the information into an R dataframe.

> This is by design a very open ended assignment.  A variety of reasonable approaches are acceptable.  You can (and should) blank out your SQL password if your solution requires it; otherwise, full credit requires that your code is "reproducible," with the assumption that I have the same database server and R software.


### Tutorial 

> Source: http://www.datacarpentry.org/R-ecology-lesson/05-r-and-databases.html

### Packages

* RMySQL --> package that allows us to connect to MySQL database directly from R
* dplyr --> allows us to query/retrieve data from database as needed
* dbplyr --> allows us to edit database directly

* install the dbplyr for RMySQL 
* Code: install.packages(c("dbplyr", "RMySQL"))


### Load libraries

```r
library(RMySQL)
```

```
## Warning: package 'RMySQL' was built under R version 3.4.3
```

```
## Loading required package: DBI
```

```
## Warning: package 'DBI' was built under R version 3.4.3
```

```r
library(dplyr)
```

```
## Warning: package 'dplyr' was built under R version 3.4.3
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(dbplyr)
```

```
## Warning: package 'dbplyr' was built under R version 3.4.3
```

```
## 
## Attaching package: 'dbplyr'
```

```
## The following objects are masked from 'package:dplyr':
## 
##     ident, sql
```

### Connect to MySQL database running locally

> I am connecting to a MySQL server that is local to my computer at home. 
The "data607_hw2" MySQL database has 2 tables: movies, and movie_ratings. 


```r
con <- DBI::dbConnect(RMySQL::MySQL(), dbname = "data607_hw2", user="root", password="P@55w0rd123!")

#get info on the database
src_dbi(con)
```

```
## src:  mysql 5.7.21-log [root@localhost:/data607_hw2]
## tbls: movie_ratings, movies
```


### Query tables and create data frame


```r
#movies table
movies <- tbl(con, sql("SELECT movie_id, movie_title, movie_year FROM movies"))

#ratings table
ratings <- tbl(con, sql("SELECT * FROM movie_ratings"))

#JOIN of both movies and ratings table
movies_ratings <- tbl(con, sql("SELECT a.rating_id, a.rating, b.movie_title, b.movie_year
             FROM movie_ratings a JOIN movies b ON a.movie_id = b.movie_id"))

movies_ratings_df <- as.data.frame(movies_ratings)

#data frame: 
dim(movies_ratings_df)
```

```
## [1] 12  4
```

```r
movies_ratings_df
```

```
##    rating_id rating                                movie_title movie_year
## 1          1      5                               PETER RABBIT       2018
## 2          7      4                               PETER RABBIT       2018
## 3          2      5                              BLACK PANTHER       2018
## 4          8      3                              BLACK PANTHER       2018
## 5          3      5             JUMANJI: WELCOME TO THE JUNGLE       2017
## 6          9      3             JUMANJI: WELCOME TO THE JUNGLE       2017
## 7          4      4                            DEN OF THIEVES        2018
## 8         10      2                            DEN OF THIEVES        2018
## 9          5      3 FIFTY SHADES FREED FAVORITE THEATER BUTTON       2018
## 10        11      4 FIFTY SHADES FREED FAVORITE THEATER BUTTON       2018
## 11         6      5                       THE GREATEST SHOWMAN       2018
## 12        12      4                       THE GREATEST SHOWMAN       2018
```
