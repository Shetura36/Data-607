---
title: "Data 607 Week 3 Assignment"
author: "Sherranette Tinapunan"
date: "February 17, 2018"
output: 
  html_document: 
    keep_md: yes
---



---------------------------------------
---------------------------------------


### Textbook: 

> Automated Data Collection with R: A Practical Guide to Web Scraping and Text Mining, Simon Munzert, Christian Rubba, Peter Meißner, and Dominic Nyhuis.  Wiley, 2015.


---------------------------------------
---------------------------------------

### Chapter 8: Problem 3

#### Copy the introductory example. The vector stores the extracted names.

R> name

[1] "Moe Szyslak" "Burns, C. Montgomery" "Rev. Timothy Lovejoy"

[4] "Ned Flanders" "Simpson, Homer" "Dr. Julius Hibbert"


```r
library(stringr)

raw.data <- "555-1239Moe Szyslak(636) 555-0113Burns, C. Montgomery555-6542Rev. Timothy Lovejoy555 8904Ned Flanders636-555-3226Simpson, Homer5553642Dr. Julius Hibbert"

name <- unlist(str_extract_all(raw.data, "[[:alpha:]., ]{2,}"))

name
```

```
## [1] "Moe Szyslak"          "Burns, C. Montgomery" "Rev. Timothy Lovejoy"
## [4] "Ned Flanders"         "Simpson, Homer"       "Dr. Julius Hibbert"
```

#### (a) Use the tools of this chapter to rearrange the vector so that all elements conform to the standard first_name last_name.

|Name Format                                 | Format Label  | String Pattern
---------------------------------------------|:-------------:|:--------------------------------------------------------------:|
|[First Name] [Last Name]                    | Format 1      | "[a-zA-Z]{3,}[ ]{1,}([a-zA-Z]){3,}"                            |
|[Last Name], [First Name]                   | Format 2      | "[a-zA-Z]{3,}[ ]\*,[ ]\*[a-zA-Z]{3,}"                          |
|[Last Name], [Middle Initial]. [First Name] | Format 3      | "[a-zA-Z]{3,}[ ]\*,[ ]\*[a-zA-Z]{1}[ ]\*[.][ ]\*[a-zA-Z]{3,}"  |

#### Create helper functions

```r
getFormatPattern <- function(str_format_label){
  
  if(str_format_label == "Format 1"){return("[a-zA-Z]{3,}[ ]{1,}([a-zA-Z]){3,}")}
  if(str_format_label == "Format 2"){return("[a-zA-Z]{3,}[ ]*,[ ]*[a-zA-Z]{3,}")}
  if(str_format_label == "Format 3"){return("[a-zA-Z]{3,}[ ]*,[ ]*[a-zA-Z]{1}[ ]*[.][ ]*[a-zA-Z]{3,}")}
  return("Format Undefned")
}

getFormat <- function(str) {
  
  if(str_detect(str, getFormatPattern("Format 1"))==TRUE){return("Format 1")}
  if(str_detect(str, getFormatPattern("Format 2"))==TRUE){return("Format 2")}
  if(str_detect(str, getFormatPattern("Format 3"))==TRUE){return("Format 3")}
  return("Format Undefined")
}

convert_to_FirstLast <- function(str_name, str_format_label){
  
  #str_name contains the pattern [first name] [last name]
  if(str_format_label == "Format 1"){
    return (str_extract(str_name, getFormatPattern("Format 1")))
  }
  # str_name contains the pattern [last name], [first name]
  if(str_format_label == "Format 2"){
    name_parts <- unlist(str_split(str_extract(str_name, getFormatPattern("Format 2")), ","))
    return(str_c(str_trim(name_parts[2]), str_trim(name_parts[1]), sep= " "))
  }
  # str_name contains the pattern [last name], [middle initial]. [ firts name]
  if(str_format_label == "Format 3"){
    name_parts <- unlist(str_split(str_extract(str_name, getFormatPattern("Format 3")), ","))
    part1 <- str_trim(name_parts[1])
    part2 <- str_trim(name_parts[2])
    part3 <- unlist(str_split(part2, "\\."))
    part4 <- str_trim(part3[2])
    return(str_c(part4, part1, sep=" "))
  }
  return("Format undefined: cannot rearrange to [first name] [last name] format")
}
```

#### Convert Names to [First Name] [Last Name] Formats


```r
result <- unlist(sapply(name, getFormat))

result
```

```
##          Moe Szyslak Burns, C. Montgomery Rev. Timothy Lovejoy 
##           "Format 1"           "Format 3"           "Format 1" 
##         Ned Flanders       Simpson, Homer   Dr. Julius Hibbert 
##           "Format 1"           "Format 2"           "Format 1"
```

```r
firstName_lastName <- unlist(mapply(convert_to_FirstLast,str_name = name, str_format_label=result))

names(firstName_lastName) <- NULL

#Original Names: 
name
```

```
## [1] "Moe Szyslak"          "Burns, C. Montgomery" "Rev. Timothy Lovejoy"
## [4] "Ned Flanders"         "Simpson, Homer"       "Dr. Julius Hibbert"
```

```r
#[First Name] [Last Name] Formats:
firstName_lastName
```

```
## [1] "Moe Szyslak"      "Montgomery Burns" "Timothy Lovejoy" 
## [4] "Ned Flanders"     "Homer Simpson"    "Julius Hibbert"
```

#### (b) Construct a logical vector indicating whether a character has a title (i.e.,and Rev. Dr.).

* A title string is a string with 2 to 3 characters followed by the period symbol.
* The title string must be at the beginning of the name.
* The string after the title is not checked for any patterns except the title is followed by a series of alpha characters at least 3 characters in lenght with spaces allowed. 

|Name Format                                 | String Pattern
---------------------------------------------|:---------------------------------------------:|
|[Title]. [First Name] [Last Name]           | "^([a-zA-Z]{2,3})[ ]\*[.][ ]\*[a-zA-Z ]{3,}"  |                       


```r
hasTitle <- function(str_name){
  titlePattern <- "^([a-zA-Z]{2,3})[ ]*[.][ ]*[a-zA-Z ]{3,}"
  return (str_detect(str_name, titlePattern))
}

sapply(name, hasTitle)
```

```
##          Moe Szyslak Burns, C. Montgomery Rev. Timothy Lovejoy 
##                FALSE                FALSE                 TRUE 
##         Ned Flanders       Simpson, Homer   Dr. Julius Hibbert 
##                FALSE                FALSE                 TRUE
```

#### (c) Construct a logical vector indicating whether a character has a second name

> I'm actually not sure what this mean exactly. I am going to assume that a second name are first names with hyphens or two first names. For example, "Jennifer-Anne James" or "Jennifer Anne James" or "James, Jennifer-Anne" or "James, Jennifer Anne" would be considered a name that has a second name. 


|Two Name Format                             | String Pattern
---------------------------------------------|:------------------------------------------------------------:|
|Jennifer-Anne James                         |"[a-zA-Z]{2,}[ ]\*-[ ]\*[a-zA-Z]{2,}[ ]{1,}[a-zA-Z]{2,}"      |   
|Jennifer Anne James                         |"[a-zA-Z]{2,}[ ]{1,}[a-zA-Z]{2,}[ ]{1,}[a-zA-Z]{2,}"          |
|James, Jennifer-Anne                        |"[a-zA-Z]{2,}[ ]*,[ ]{1,}[a-zA-Z]{2,}[ ]\*-[ ]\*[a-zA-Z]{2,}" |
|James, Jennifer Anne                        |"[a-zA-Z]{2,}[ ]*,[ ]{1,}[a-zA-Z]{2,}[ ]{1,}[a-zA-Z]{2,}"     |


#### Create function to determine if name has two names.
#### Apply function to a list of names. 


```r
hasTwoNames <- function(str_name){
  
  pattern1 <- "[a-zA-Z]{2,}[ ]*-[ ]*[a-zA-Z]{2,}[ ]{1,}[a-zA-Z]{2,}" #Jennifer-Anne James format
  pattern2 <- "[a-zA-Z]{2,}[ ]{1,}[a-zA-Z]{2,}[ ]{1,}[a-zA-Z]{2,}" #Jennifer Anne James format
  pattern3 <- "[a-zA-Z]{2,}[ ]*,[ ]{1,}[a-zA-Z]{2,}[ ]*-[ ]*[a-zA-Z]{2,}" #James, Jennifer-Anne format
  pattern4 <- "[a-zA-Z]{2,}[ ]*,[ ]{1,}[a-zA-Z]{2,}[ ]{1,}[a-zA-Z]{2,}" #James, Jennifer Anne format
  
  is_pattern1 = str_detect(str_name, pattern1)
  is_pattern2 = str_detect(str_name, pattern2)
  is_pattern3 = str_detect(str_name, pattern3)
  is_pattern4 = str_detect(str_name, pattern4)
  
  return(is_pattern1 | is_pattern2 | is_pattern3 | is_pattern4)
}

some_names = c("Jennifer-Anne James", "Smith, Mary-Jane", "Kalel Samuel Lassalle", "Sanchez, Mark Anthony", "Juancarlo Ventura", "Ventura, Shey")

sapply(some_names, hasTwoNames)
```

```
##   Jennifer-Anne James      Smith, Mary-Jane Kalel Samuel Lassalle 
##                  TRUE                  TRUE                  TRUE 
## Sanchez, Mark Anthony     Juancarlo Ventura         Ventura, Shey 
##                  TRUE                 FALSE                 FALSE
```

---------------------------------------
---------------------------------------

### Chapter 8: Problem 4

> Describe the types of strings that conform to the following regular expressions and
construct an example that is matched by the regular expression.

#### (a) [0-9]+\\\\$

> A string with a pattern of numbers that occurs at least once and followed by the literal $ sign 


```r
str_example = "Hello 123$"
str_extract(str_example, "[0-9]+\\$")
```

```
## [1] "123$"
```

#### (b) \\\\b[a-z]{1,4}\\\\b

> A pattern that looks for the first occurrence of a word with only lowercase letters with length of 1 to 4. 


```r
str_example = "hello Jam care bale"
str_extract(str_example, "\\b[a-z]{1,4}\\b")
```

```
## [1] "care"
```

#### (c) .*?\\\\.txt$

> A pattern that looks for any combination of characters than ends in .txt


```r
str_example = "hello w%34abCzY.txt"
str_extract(str_example, ".*?\\.txt$")
```

```
## [1] "hello w%34abCzY.txt"
```

#### (d) \\\\d{2}/\\\\d{2}/\\\\d{4}

> A pattern that looks for (2 numbers)/(2 numbers)/(4 numbers)


```r
str_example = "1278 12/34/56784 9"
str_extract(str_example, "\\d{2}/\\d{2}/\\d{4}")
```

```
## [1] "12/34/5678"
```

#### (e) <(.+?)>.+?</\\\\1>

> A pattern that looks for a string that looks something like "\<some description\> some data inside \</some description\>", where the value of "some description" has to be at least one character in length. The value of the end tag has to be the same as the open tag. 


```r
str_example = "hello <p>this is a paragraph 123</p> hello"
str_extract(str_example, " <(.+?)>.+?</\\1>")
```

```
## [1] " <p>this is a paragraph 123</p>"
```

