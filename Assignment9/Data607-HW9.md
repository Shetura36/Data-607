---
title: "Data 607 Week 9 Assignment"
author: "S. Tinapunan"
date: "March 30, 2018"
output: 
  html_document: 
    keep_md: yes
---




```r
library(httr)
library(jsonlite)
library(knitr)
library(DT)
```
### New York Time's Movie Reviews API

Details: 
http://developer.nytimes.com/movie_reviews_v2.json#/Documentation/GET/reviews/%7Bresource-type%7D.json

---------

### Retrieve data
Retrieve all movie reviews for nytimes.com movie reviews API. 

Specify `all.jason` to retrieve all reviews, including NYT Critics' Picks.

```r
url <- "https://api.nytimes.com/svc/movies/v2/reviews/all.json"

movie_reviews <- GET(url, query = list("api-key" = "375b94ee380a4da8b23bf46b26ee274b"))
content <- content(movie_reviews, "text")
movie_reviews
```

```
## Response [https://api.nytimes.com/svc/movies/v2/reviews/all.json?api-key=375b94ee380a4da8b23bf46b26ee274b]
##   Date: 2018-03-31 19:41
##   Status: 200
##   Content-Type: application/json; charset=UTF-8
##   Size: 16.6 kB
```

---------

### Store movie review results as data frame

```r
movie_data <- fromJSON(content)
results <- as.data.frame(movie_data$results)
```

---------

### Column names on data frame

There are 11 column names in the data frame. 

Columns `link` and `multimedia` are lists. The `link` list contains the link information to the movie review article. The `multimedia` list contains graphics data for the movie. 


```r
kable(names(results), format="markdown")
```



|x                |
|:----------------|
|display_title    |
|mpaa_rating      |
|critics_pick     |
|byline           |
|headline         |
|summary_short    |
|publication_date |
|opening_date     |
|date_updated     |
|link             |
|multimedia       |

```r
kable(names(results$link), format="markdown")
```



|x                   |
|:-------------------|
|type                |
|url                 |
|suggested_link_text |

```r
kable(names(results$multimedia), format="markdown")
```



|x      |
|:------|
|type   |
|src    |
|width  |
|height |

---------

### Number of movie reviews returned by API data request

There are 20 movie review articles returned from the movie review API data request. 

```r
nrow(results)
```

```
## [1] 20
```

---------

### Display results

This displays all the columns of the first 3 rows except `multimedia`. 

The `multimedia` column is a list that contains information on graphics related to the movie reviews. 


```r
all <- cbind(results[1:9], results$link$type, results$link$url,results$link$suggested_link_text)
kable(head(all,3), format="markdown")
```



|display_title          |mpaa_rating | critics_pick|byline         |headline                                                                 |summary_short                                                                                                 |publication_date |opening_date |date_updated        |results$link$type |results$link$url                                                                          |results$link$suggested_link_text                         |
|:----------------------|:-----------|------------:|:--------------|:------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------|:----------------|:------------|:-------------------|:-----------------|:-----------------------------------------------------------------------------------------|:--------------------------------------------------------|
|Tyler Perry's Acrimony |R           |            0|BEN KENIGSBERG |Review: In ‘Acrimony,’ Taraji P. Henson Endures Marriage and Script Woes |The Tyler Perry melodrama follows a woman who undergoes trials brought on by a cheating husband (Lyriq Bent). |2018-03-30       |2018-03-30   |2018-03-31 16:44:33 |article           |http://www.nytimes.com/2018/03/30/movies/acrimony-review-taraji-p-henson-tyler-perry.html |Read the New York Times Review of Tyler Perry's Acrimony |
|Wilde Salomé           |R           |            1|GLENN KENNY    |Review: Al Pacino’s Journey With Wilde’s ‘Salomé’                        |A story of obsession plays out in “Wilde Salomé” and “Salomé,” as Mr. Pacino veers into Camp.                 |2018-03-29       |2017-04-01   |2018-03-31 16:44:31 |article           |http://www.nytimes.com/2018/03/29/movies/wilde-salome-review-al-pacino.html               |Read the New York Times Review of Wilde Salomé           |
|Salomé                 |R           |            1|GLENN KENNY    |Review: Al Pacino’s Journey With Wilde’s ‘Salomé’                        |A story of obsession plays out in “Wilde Salomé” and “Salomé,” as Mr. Pacino veers into Camp.                 |2018-03-29       |NA           |2018-03-29 12:04:03 |article           |http://www.nytimes.com/2018/03/29/movies/wilde-salome-review-al-pacino.html               |Read the New York Times Review of Salomé                 |

```r
#datatable(all,class = 'cell-border stripe')
```

---------

### Create column that displays "yes" if movie was picked by critics
 
Displaying "yes" instead of "1" is more user-friendly. This user-friendly column is going to be used when the complete list of movie reviews is generated below. 

```r
yesOrNo <- function (value){
  if(value==1){return("yes")}
  return("")
}
results$picked_by_critics <- unlist(sapply(results$critics_pick, yesOrNo))
#results[c(3,13)]
```

---------

### Display movie information and link to reviews in NYTimes.com

Some of the movies do not have an opening date. There is one movie that has an opening date in 1969. I double checked the text data that was returned from the API request before calling the `fromJASON` function: the text data reads `1969-00-00`.


```r
names(results)
```

```
##  [1] "display_title"     "mpaa_rating"       "critics_pick"     
##  [4] "byline"            "headline"          "summary_short"    
##  [7] "publication_date"  "opening_date"      "date_updated"     
## [10] "link"              "multimedia"        "picked_by_critics"
```

```r
friendly_display <- cbind(results[c(1,2,8,12)], results$link$url)
kable(friendly_display, format="markdown")
```



|display_title          |mpaa_rating |opening_date |picked_by_critics |results$link$url                                                                          |
|:----------------------|:-----------|:------------|:-----------------|:-----------------------------------------------------------------------------------------|
|Tyler Perry's Acrimony |R           |2018-03-30   |                  |http://www.nytimes.com/2018/03/30/movies/acrimony-review-taraji-p-henson-tyler-perry.html |
|Wilde Salomé           |R           |2017-04-01   |yes               |http://www.nytimes.com/2018/03/29/movies/wilde-salome-review-al-pacino.html               |
|Salomé                 |R           |NA           |yes               |http://www.nytimes.com/2018/03/29/movies/wilde-salome-review-al-pacino.html               |
|Personal Problems      |            |NA           |yes               |http://www.nytimes.com/2018/03/29/movies/personal-problems-review.html                    |
|Love After Love        |            |2018-03-30   |yes               |http://www.nytimes.com/2018/03/29/movies/love-after-love-review.html                      |
|Outside In             |            |2018-04-03   |yes               |http://www.nytimes.com/2018/03/29/movies/outside-in-review-jay-duplass-edie-falco.html    |
|Gemini                 |R           |2018-03-30   |                  |http://www.nytimes.com/2018/03/29/movies/gemini-review-lola-kirke-zoe-kravitz.html        |
|The Gardener           |            |2018-03-30   |                  |http://www.nytimes.com/2018/03/29/movies/the-gardener-review.html                         |
|After Louie            |            |2018-03-30   |                  |http://www.nytimes.com/2018/03/29/movies/after-louie-review-alan-cumming.html             |
|All I Wish             |            |2018-03-30   |                  |http://www.nytimes.com/2018/03/29/movies/all-i-wish-review-sharon-stone.html              |
|The Last Movie Star    |R           |2018-03-30   |                  |http://www.nytimes.com/2018/03/29/movies/the-last-movie-star-review-burt-reynolds.html    |
|The China Hustle       |R           |2018-03-23   |                  |http://www.nytimes.com/2018/03/29/movies/the-china-hustle-review.html                     |
|Finding Your Feet      |PG-13       |NA           |                  |http://www.nytimes.com/2018/03/29/movies/finding-your-feet-review.html                    |
|Ready Player One       |PG-13       |2018-03-29   |                  |http://www.nytimes.com/2018/03/28/movies/ready-player-one-review-steven-spielberg.html    |
|The Great Silence      |Not Rated   |1969-00-00   |                  |http://www.nytimes.com/2018/03/28/movies/the-great-silence-review-sergio-corbucci.html    |
|Midnight Sun           |PG-13       |2018-03-23   |                  |http://www.nytimes.com/2018/03/23/movies/midnight-sun-review.html                         |
|Ismael's Ghosts        |R           |2018-03-23   |yes               |http://www.nytimes.com/2018/03/22/movies/review-ismaels-ghosts-arnaud-desplechin.html     |
|Beauty and the Dogs    |            |NA           |yes               |http://www.nytimes.com/2018/03/22/movies/beauty-and-the-dogs-review.html                  |
|The Workshop           |            |NA           |yes               |http://www.nytimes.com/2018/03/22/movies/the-workshop-review-laurent-cantet.html          |
|I Kill Giants          |Not Rated   |2018-03-23   |yes               |http://www.nytimes.com/2018/03/22/movies/i-kill-giants-review.html                        |

---------

### Display short summary of movies

I decided to display this in a separate table because the summary content is lengthier than the other columns. It would be easier to read this way. 


```r
kable(results[c(1,8,6)])
```



display_title            opening_date   summary_short                                                                                                                                                        
-----------------------  -------------  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
Tyler Perry's Acrimony   2018-03-30     The Tyler Perry melodrama follows a woman who undergoes trials brought on by a cheating husband (Lyriq Bent).                                                        
Wilde Salomé             2017-04-01     A story of obsession plays out in “Wilde Salomé” and “Salomé,” as Mr. Pacino veers into Camp.                                                                        
Salomé                   NA             A story of obsession plays out in “Wilde Salomé” and “Salomé,” as Mr. Pacino veers into Camp.                                                                        
Personal Problems        NA             The brainchild of the writer Ishmael Reed and the director Bill Gunn, this film is an uncategorizable work of art — and an engrossing one.                           
Love After Love          2018-03-30     Russ Harbaugh’s debut feature delivers something rarely seen in American movies: a warts-and-all examination of extended grief.                                      
Outside In               2018-04-03     Edie Falco and Jay Duplass connect romantically in this life-after-prison drama that prioritizes patience and pragmatism over passion.                               
Gemini                   2018-03-30     The director Aaron Katz plays with film noir conventions in this pleasurably drifty, low-wattage mystery.                                                            
The Gardener             2018-03-30     Frank Cabot’s garden in Quebec is in part an amalgamation of others that inspired him in his travels.                                                                
After Louie              2018-03-30     The film, starring Alan Cumming, centers on a 50-something man who lived through the worst years of the AIDS epidemic.                                               
All I Wish               2018-03-30     A fine performance by Ms. Stone is up against a generic screenplay.                                                                                                  
The Last Movie Star      2018-03-30     The film effectively allows the ever-assured actor to score a touchdown on an empty field.                                                                           
The China Hustle         2018-03-23     A documentary may be the wrong delivery mechanism for the byzantine exposé that cries out for detailed news reporting.                                               
Finding Your Feet        NA             Led by a charming pairing of Imelda Staunton and Celia Imrie, this British retiree rom-com delivers exactly what it promises.                                        
Ready Player One         2018-03-29     The movie, based on Ernest Cline’s best-selling novel, is set in a dystopian future where a virtual video-game reality reigns, and pop-culture callbacks are legion. 
The Great Silence        1969-00-00     Klaus Kinski and Jean-Louis Trintignant face off in the snows of Utah in a bloody genre exercise that is only now receiving a proper U.S. release.                   
Midnight Sun             2018-03-23     Bella Thorne stars as a teenager with a rare disease who must avoid ultraviolet light — but she isn’t avoiding love. One night, she meets a boy.                     
Ismael's Ghosts          2018-03-23     In Arnaud Desplechin’s remarkable sprawl of a film, a wife comes back after a 20-year disappearance, adding to an already convoluted situation.                      
Beauty and the Dogs      NA             In this film inspired by a true story, the director Kaouther Ben Hania leans hard on official corruption and a bureaucracy dominated by male power.                  
The Workshop             NA             This new film from the French director Laurent Cantet follows a diverse group of students enrolled in a summer writing class taught by a famous novelist.            
I Kill Giants            2018-03-23     This magical movie marries adult themes and childlike wonder as a troubled girl embarks on a fantastical quest.                                                      
