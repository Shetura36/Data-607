---
title: "Data 607 Assignment 1"
author: "Sherranette Tinapunan"
date: "February 3, 2018"
output: 
  html_document: 
    keep_md: yes
---



### Task
Your task is to study the dataset and the associated description of the data (i.e. "data dictionary"). You may need to look around a bit, but it's there! You should take the data, and create a data frame with a subset of the columns in the dataset. You should include the column that indicates edible or poisonous and three or four other columns. You should also add meaningful column names and replace the abbreviations used in the data-for example, in the appropriate column, "e" might become "edible."


### Mushroom data set
- Source: https://archive.ics.uci.edu/ml/datasets/Mushroom
- No. of observations 8124
- No. of attributes 22
- Data source file does not have column lables
- First column is classification of whether mushroom is edible or poisonous

### Attributes
Attribute Information: (classes: edible=e, poisonous=p)

     1. cap-shape:                bell=b,conical=c,convex=x,flat=f,
                                  knobbed=k,sunken=s
     2. cap-surface:              fibrous=f,grooves=g,scaly=y,smooth=s
     3. cap-color:                brown=n,buff=b,cinnamon=c,gray=g,green=r,
                                  pink=p,purple=u,red=e,white=w,yellow=y
     4. bruises?:                 bruises=t,no=f
     5. odor:                     almond=a,anise=l,creosote=c,fishy=y,foul=f,
                                  musty=m,none=n,pungent=p,spicy=s
     6. gill-attachment:          attached=a,descending=d,free=f,notched=n
     7. gill-spacing:             close=c,crowded=w,distant=d
     8. gill-size:                broad=b,narrow=n
     9. gill-color:               black=k,brown=n,buff=b,chocolate=h,gray=g,
                                  green=r,orange=o,pink=p,purple=u,red=e,
                                  white=w,yellow=y
    10. stalk-shape:              enlarging=e,tapering=t
    11. stalk-root:               bulbous=b,club=c,cup=u,equal=e,
                                  rhizomorphs=z,rooted=r,missing=?
    12. stalk-surface-above-ring: fibrous=f,scaly=y,silky=k,smooth=s
    13. stalk-surface-below-ring: fibrous=f,scaly=y,silky=k,smooth=s
    14. stalk-color-above-ring:   brown=n,buff=b,cinnamon=c,gray=g,orange=o,
                                  pink=p,red=e,white=w,yellow=y
    15. stalk-color-below-ring:   brown=n,buff=b,cinnamon=c,gray=g,orange=o,
                                  pink=p,red=e,white=w,yellow=y
    16. veil-type:                partial=p,universal=u
    17. veil-color:               brown=n,orange=o,white=w,yellow=y
    18. ring-number:              none=n,one=o,two=t
    19. ring-type:                cobwebby=c,evanescent=e,flaring=f,large=l,
                                  none=n,pendant=p,sheathing=s,zone=z
    20. spore-print-color:        black=k,brown=n,buff=b,chocolate=h,green=r,
                                  orange=o,purple=u,white=w,yellow=y
    21. population:               abundant=a,clustered=c,numerous=n,
                                  scattered=s,several=v,solitary=y
    22. habitat:                  grasses=g,leaves=l,meadows=m,paths=p,
                                  urban=u,waste=w,woods=d

### Selected attributes

- odor --> attribute no. 5 --> column no. 6
- spore_print_color --> attribute no. 20 --> column no. 21
- population --> attribute no. 21 --> column no. 22
- habitat --> attribute no. 22 --> column no. 23



### Load data from from CSV file
-  CSV file does not have column names. 

```r
getwd()
```

```
## [1] "C:/Users/stina/Documents/GitHub/Data-607-Assignments/Assignment1"
```

```r
data <- read.csv("./Assignment1_files/agaricus-lepiota.csv", header=FALSE)
```

### Summary of data

```r
summary(data)
```

```
##  V1       V2       V3             V4       V5             V6      
##  e:4208   b: 452   f:2320   n      :2284   f:4748   n      :3528  
##  p:3916   c:   4   g:   4   g      :1840   t:3376   f      :2160  
##           f:3152   s:2556   e      :1500            s      : 576  
##           k: 828   y:3244   y      :1072            y      : 576  
##           s:  32            w      :1040            a      : 400  
##           x:3656            b      : 168            l      : 400  
##                             (Other): 220            (Other): 484  
##  V7       V8       V9            V10       V11      V12      V13     
##  a: 210   c:6812   b:5612   b      :1728   e:3516   ?:2480   f: 552  
##  f:7914   w:1312   n:2512   p      :1492   t:4608   b:3776   k:2372  
##                             w      :1202            c: 556   s:5176  
##                             n      :1048            e:1120   y:  24  
##                             g      : 752            r: 192           
##                             h      : 732                             
##                             (Other):1170                             
##  V14           V15            V16       V17      V18      V19     
##  f: 600   w      :4464   w      :4384   p:8124   n:  96   n:  36  
##  k:2304   p      :1872   p      :1872            o:  96   o:7488  
##  s:4936   g      : 576   g      : 576            w:7924   t: 600  
##  y: 284   n      : 448   n      : 512            y:   8           
##           b      : 432   b      : 432                             
##           o      : 192   o      : 192                             
##           (Other): 140   (Other): 156                             
##  V20           V21       V22      V23     
##  e:2776   w      :2388   a: 384   d:3148  
##  f:  48   n      :1968   c: 340   g:2148  
##  l:1296   k      :1872   n: 400   l: 832  
##  n:  36   h      :1632   s:1248   m: 292  
##  p:3968   r      :  72   v:4040   p:1144  
##           b      :  48   y:1712   u: 368  
##           (Other): 144            w: 192
```

```r
head(data)
```

```
##   V1 V2 V3 V4 V5 V6 V7 V8 V9 V10 V11 V12 V13 V14 V15 V16 V17 V18 V19 V20
## 1  p  x  s  n  t  p  f  c  n   k   e   e   s   s   w   w   p   w   o   p
## 2  e  x  s  y  t  a  f  c  b   k   e   c   s   s   w   w   p   w   o   p
## 3  e  b  s  w  t  l  f  c  b   n   e   c   s   s   w   w   p   w   o   p
## 4  p  x  y  w  t  p  f  c  n   n   e   e   s   s   w   w   p   w   o   p
## 5  e  x  s  g  f  n  f  w  b   k   t   e   s   s   w   w   p   w   o   e
## 6  e  x  y  y  t  a  f  c  b   n   e   c   s   s   w   w   p   w   o   p
##   V21 V22 V23
## 1   k   s   u
## 2   n   n   g
## 3   n   n   m
## 4   k   s   u
## 5   n   a   g
## 6   k   n   g
```

### Create subset with only selected columns
- class:              column 1
- odor:               column 6
- spore-print-color:  column 21
- population:         column 22
- habitat:            column 23



```r
mushroom_data <- data[, c(1,6,21,22,23)]
head(mushroom_data)
```

```
##   V1 V6 V21 V22 V23
## 1  p  p   k   s   u
## 2  e  a   n   n   g
## 3  e  l   n   n   m
## 4  p  p   k   s   u
## 5  e  n   n   a   g
## 6  e  a   k   n   g
```

### Rename selected columns

```r
colnames(mushroom_data)
```

```
## [1] "V1"  "V6"  "V21" "V22" "V23"
```

```r
colnames(mushroom_data) <- c('class', 'odor', 'spore_print_color', 'population', 'habitat')
colnames(mushroom_data)
```

```
## [1] "class"             "odor"              "spore_print_color"
## [4] "population"        "habitat"
```

```r
head(mushroom_data)
```

```
##   class odor spore_print_color population habitat
## 1     p    p                 k          s       u
## 2     e    a                 n          n       g
## 3     e    l                 n          n       m
## 4     p    p                 k          s       u
## 5     e    n                 n          a       g
## 6     e    a                 k          n       g
```

### Summary and structure of mushroom subset

```r
summary(mushroom_data, maxsum=20)
```

```
##  class    odor     spore_print_color population habitat 
##  e:4208   a: 400   b:  48            a: 384     d:3148  
##  p:3916   c: 192   h:1632            c: 340     g:2148  
##           f:2160   k:1872            n: 400     l: 832  
##           l: 400   n:1968            s:1248     m: 292  
##           m:  36   o:  48            v:4040     p:1144  
##           n:3528   r:  72            y:1712     u: 368  
##           p: 256   u:  48                       w: 192  
##           s: 576   w:2388                               
##           y: 576   y:  48
```

```r
str(mushroom_data)
```

```
## 'data.frame':	8124 obs. of  5 variables:
##  $ class            : Factor w/ 2 levels "e","p": 2 1 1 2 1 1 1 1 2 1 ...
##  $ odor             : Factor w/ 9 levels "a","c","f","l",..: 7 1 4 7 6 1 1 4 7 1 ...
##  $ spore_print_color: Factor w/ 9 levels "b","h","k","n",..: 3 4 4 3 4 3 3 4 3 3 ...
##  $ population       : Factor w/ 6 levels "a","c","n","s",..: 4 3 3 4 1 3 3 4 5 4 ...
##  $ habitat          : Factor w/ 7 levels "d","g","l","m",..: 6 2 4 6 2 2 4 4 2 4 ...
```

### Dictionary of abbreviations for selected attributes

* class: 
    + e=edible, p=poisonous
    
* odor: 
    + almond=a, anise=l, creosote=c, fishy=y, foul=f, musty=m, none=n, pungent=p, spicy=s
    
* spore-print-color: 
    + black=k, brown=n, buff=b, chocolate=h, green=r, orange=o, purple=u, white=w, yellow=y
    
* population: 
    + abundant=a, clustered=c, numerous=n, scattered=s, several=v, solitary=y
    
* habitat:
    + grasses=g, leaves=l, meadows=m, paths=p, urban=u, waste=w, woods=d
  

### Replace abbreviations with full description

```r
levels(mushroom_data$class) <- list(edible="e", poisonous="p")

levels(mushroom_data$odor) <- list(almond="a", anise="l", creosote="c", fishy="y", foul="f", musty="m",                                       none="n", pungent="p", spicy="s")

levels(mushroom_data$spore_print_color) <- list(black="k", brown="n", buff="b", chocolate="h", green="r",   
                                                orange="o", purple="u", white="w", yellow="y")

levels(mushroom_data$population) <- list(abundant="a", clustered="c", numerous="n", scattered="s", 
                                         several="v", solitary="y")

levels(mushroom_data$habitat) <- list(grasses="g", leaves="l", meadows="m", paths="p", urban="u", waste="w", 
                                      woods="d")

summary(mushroom_data, maxsum=20)
```

```
##        class            odor      spore_print_color     population  
##  edible   :4208   almond  : 400   black    :1872    abundant : 384  
##  poisonous:3916   anise   : 400   brown    :1968    clustered: 340  
##                   creosote: 192   buff     :  48    numerous : 400  
##                   fishy   : 576   chocolate:1632    scattered:1248  
##                   foul    :2160   green    :  72    several  :4040  
##                   musty   :  36   orange   :  48    solitary :1712  
##                   none    :3528   purple   :  48                    
##                   pungent : 256   white    :2388                    
##                   spicy   : 576   yellow   :  48                    
##     habitat    
##  grasses:2148  
##  leaves : 832  
##  meadows: 292  
##  paths  :1144  
##  urban  : 368  
##  waste  : 192  
##  woods  :3148  
##                
## 
```

```r
head(mushroom_data, 50)
```

```
##        class    odor spore_print_color population habitat
## 1  poisonous pungent             black  scattered   urban
## 2     edible  almond             brown   numerous grasses
## 3     edible   anise             brown   numerous meadows
## 4  poisonous pungent             black  scattered   urban
## 5     edible    none             brown   abundant grasses
## 6     edible  almond             black   numerous grasses
## 7     edible  almond             black   numerous meadows
## 8     edible   anise             brown  scattered meadows
## 9  poisonous pungent             black    several grasses
## 10    edible  almond             black  scattered meadows
## 11    edible   anise             brown   numerous grasses
## 12    edible  almond             black  scattered meadows
## 13    edible  almond             brown  scattered grasses
## 14 poisonous pungent             brown    several   urban
## 15    edible    none             black   abundant grasses
## 16    edible    none             brown   solitary   urban
## 17    edible    none             brown   abundant grasses
## 18 poisonous pungent             black  scattered grasses
## 19 poisonous pungent             brown  scattered   urban
## 20 poisonous pungent             brown  scattered   urban
## 21    edible  almond             brown  scattered meadows
## 22 poisonous pungent             brown    several grasses
## 23    edible   anise             brown  scattered meadows
## 24    edible  almond             brown   numerous meadows
## 25    edible   anise             black  scattered meadows
## 26 poisonous pungent             brown    several grasses
## 27    edible  almond             brown   numerous meadows
## 28    edible   anise             brown   numerous meadows
## 29    edible    none             black   solitary   urban
## 30    edible  almond             brown    several   woods
## 31    edible   anise             brown   numerous meadows
## 32 poisonous pungent             brown  scattered   urban
## 33    edible   anise             brown   numerous meadows
## 34    edible   anise             brown   solitary   paths
## 35    edible   anise             brown  scattered meadows
## 36    edible   anise             brown    several   woods
## 37    edible    none             black    several   urban
## 38 poisonous pungent             brown  scattered   urban
## 39    edible  almond             brown    several   woods
## 40    edible   anise             black  scattered meadows
## 41    edible  almond             brown  scattered grasses
## 42    edible   anise             black   solitary   paths
## 43    edible    none             black   solitary   urban
## 44 poisonous pungent             brown    several grasses
## 45    edible  almond             black   numerous meadows
## 46    edible  almond             brown   numerous grasses
## 47    edible   anise             black  scattered meadows
## 48    edible   anise             brown   numerous meadows
## 49    edible   anise             brown  scattered   paths
## 50    edible   anise             black  scattered   paths
```


