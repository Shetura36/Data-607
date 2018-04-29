---
title: "Data 607 Homework 13"
author: "S. Tinapunan"
date: "April 29, 2018"
output: 
  html_document: 
    keep_md: yes
---

-----

### Migrating tables from MySQL to NoSQL database

In this assignment, I'm doing a very simple migration of the MySQL database that was previously created in week 2 assignment. This is a database that has two tables: movies and movie rantings. 

MySQL is a relational database and works well with requirements that are known during the design phase. Data can be stored accross different tables to normalize the tables. As result, queries in relational databases typically take longer compared to NoSQL database. NoSQL database works well for requirements that are not really known during the design phase. However, there's no normalization for NoSQL databases. As a result, it is recommended to store all information in a document. Because of how records are stored in a NoSQL database, queries are faster compared with SQL database. NoSQL datbases are also scalable.

-----




```r
library(RMySQL)
library(mongolite)
library(dbplyr)
library(dplyr)
library(knitr)
```



-----

### Connect to MySQL database running locally.

I am connecting to a MySQL server that is local to my computer at home. 
The "data607_hw2" MySQL database has 2 tables: movies, and movie_ratings. 


```r
con <- DBI::dbConnect(RMySQL::MySQL(), dbname = "data607_hw2", user=db_user, password=db_pw)

#get info on the database
dbplyr::src_dbi(con)
```

```
## src:  mysql 5.7.21-log [root@localhost:/data607_hw2]
## tbls: movie_ratings, movies
```

-----

### Query MySQL tables and create data frame.

The code below retrieves all the records from `movies` and `ratings` tables. 


```r
#movies table
movies <- dplyr::tbl(con, sql("SELECT movie_id, movie_title, movie_year FROM movies"))

#ratings table
ratings <- dplyr::tbl(con, sql("SELECT * FROM movie_ratings"))
```

-----

### Join MySQL `movies` and `ratings` tables.

In MongdoDB, a document should contain all data related to each item. Each document represents a rating of a movie. There are `12` movie ratings present in this small database from homework 2.

To create a complete set of information for each rating, the `movies` and `ratings` tables are going to be joined. 


```r
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
kable(movies_ratings_df, format="markdown")
```



| rating_id| rating|movie_title                                | movie_year|
|---------:|------:|:------------------------------------------|----------:|
|         1|      5|PETER RABBIT                               |       2018|
|         7|      4|PETER RABBIT                               |       2018|
|         2|      5|BLACK PANTHER                              |       2018|
|         8|      3|BLACK PANTHER                              |       2018|
|         3|      5|JUMANJI: WELCOME TO THE JUNGLE             |       2017|
|         9|      3|JUMANJI: WELCOME TO THE JUNGLE             |       2017|
|         4|      4|DEN OF THIEVES                             |       2018|
|        10|      2|DEN OF THIEVES                             |       2018|
|         5|      3|FIFTY SHADES FREED FAVORITE THEATER BUTTON |       2018|
|        11|      4|FIFTY SHADES FREED FAVORITE THEATER BUTTON |       2018|
|         6|      5|THE GREATEST SHOWMAN                       |       2018|
|        12|      4|THE GREATEST SHOWMAN                       |       2018|

-----

### Connect to MongoDB database and collection. 

The code below connects to a MongoDB named `Data607_Week13`. This was already created through MongoDB Compass application. In addition, a collection named `Movie Ratings` was created ahead of time in the database.  


```r
# create connection, database and collection
my_collection = mongolite::mongo(collection = "Movie Ratings", db = "Data607_Week13")
```

-----

### Insert movie ratings data in MongdoDB database collection. 

The 12 movie ratings in `movies_rating_df` are going to be imported in the MongoDB database collection. 

Based on observation, this code should only be run once. Running this code again will create MORE entries in the `Movie Ratings` collection. 


```r
#insert movies
my_collection$insert(movies_ratings_df)
```

```
## List of 5
##  $ nInserted  : num 12
##  $ nMatched   : num 0
##  $ nRemoved   : num 0
##  $ nUpserted  : num 0
##  $ writeErrors: list()
```

-----

### Check movies data inserted in MongoDB collections.

The code below presents the number of documents added in the collection. 


```r
my_collection$count()
```

```
## [1] 12
```

-----

### Display records in MongoDB collection.  


```r
kable(my_collection$find(), format="markdown")
```



| rating_id| rating|movie_title                                | movie_year|
|---------:|------:|:------------------------------------------|----------:|
|         1|      5|PETER RABBIT                               |       2018|
|         7|      4|PETER RABBIT                               |       2018|
|         2|      5|BLACK PANTHER                              |       2018|
|         8|      3|BLACK PANTHER                              |       2018|
|         3|      5|JUMANJI: WELCOME TO THE JUNGLE             |       2017|
|         9|      3|JUMANJI: WELCOME TO THE JUNGLE             |       2017|
|         4|      4|DEN OF THIEVES                             |       2018|
|        10|      2|DEN OF THIEVES                             |       2018|
|         5|      3|FIFTY SHADES FREED FAVORITE THEATER BUTTON |       2018|
|        11|      4|FIFTY SHADES FREED FAVORITE THEATER BUTTON |       2018|
|         6|      5|THE GREATEST SHOWMAN                       |       2018|
|        12|      4|THE GREATEST SHOWMAN                       |       2018|

-----


