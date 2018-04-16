---
title: "Project 4: Text Classification"
author: "S. Tinapunan"
date: "April 14, 2018"
output: 
  html_document: 
    keep_md: yes
---

------

### Spam-Ham Classification

This project uses *Naive Bayes* to classify plain text documents as either `spam` or `ham`. This work is based on what I learned from a YouTube lecture by UC Berkeley Prof. Pieter Abbeel on Machine Learning: Naive Bayes (https://www.youtube.com/watch?v=DNvwfNEiKvw).

The `tm` library is used to process the corpus. 

Three sets of data that were used. The `training set` was used to train the classification method. The `hold off` set was used to test the classification with different parameters to try and improve the accuracy of the classification. Finally, the `testing` set was used to test the classification once the parameters are set for the classification. 

Source of data: 
http://spamassassin.apache.org/old/publiccorpus/


<b>Training set</b>: 

* *easy* ham: filename *20021010_easy_ham.tar.bz2* (qty: 2551)
* spam: filename *20050311_spam_2.tar.bz2* (qyt: 1396)

<b>Hold off set</b>: 

* *easy* ham: filename *20030228_easy_ham_2.tar.bz2* (qty: subset of 700)
* spam: filename *20030228_spam.tar.bz2* (qty: subset of 250)

<b>Testing set</b>: 

* *easy* ham: filename *20030228_easy_ham_2.tar.bz2* (qty: subset of 701)
* *hard* ham: filename *20021010_hard_ham.tar.bz2* (qty: 250)
* spam: filename *20030228_spam.tar.bz2* (qty: subset of 251)


--------------


### Libraries


```r
library(tm)
library(dplyr)
library(ggplot2)
library(SnowballC)
library(knitr)
library(stringr)
library(DT)
```

-----

### Load `spam` and `ham` corpus

The `tm` library is used to load the files.

The code below loads the spam-ham `training` set, `hold off` set, and `testing` set.




```r
#SETS
ham_training_folder <- "./spamham/easy_ham_training_p1"
spam_training_folder <- "./spamham/spam_2_training_p2"
ham_testing_folder <- "./spamham/easy_ham_2_TESTING"
spam_testing_folder <- "./spamham/spam_TESTING"
ham_holdoff_folder <- "./spamham/easy_ham_2_HOLDOFF"
spam_holdoff_folder <- "./spamham/spam_HOLDOFF"
hard_ham_testing_folder <- "./spamham/hard_ham_TESTING"

#LOAD FILES
ham_training <- VCorpus(DirSource(ham_training_folder))  
spam_training <- VCorpus(DirSource(spam_training_folder))  
ham_testing <- VCorpus(DirSource(ham_testing_folder))  
spam_testing <- VCorpus(DirSource(spam_testing_folder))  
ham_holdoff <- VCorpus(DirSource(ham_holdoff_folder))
spam_holdoff <- VCorpus(DirSource(spam_holdoff_folder))
hard_ham_testing <- VCorpus(DirSource(hard_ham_testing_folder))

#summary(ham_training) 
#summary(spam_training)
```
-----

### Size of each file

This table lists the number of emails in the `ham` and `spam` files in each set. 


File                     No. of Emails 
-----------------------  --------------
Training Set: Easy Ham   2551          
Traning Set: Spam        1396          
Hold Off Set: Easy Ham   700           
Hold Off Set: Spam       250           
Testing Set: Easy Ham    701           
Testing Set: Spam        251           
Testing Set: Hard Ham    250           

-----

### Data preprocessing 

This simplistic approach in text classification only focuses on the English alpha characters and the case of the alpha characters is ignored. Text is converted to lowercase. Punctuations are also removed before the term document matrix and document term matrix are generated. 

Other possible features that may play a role in improving the accuracy of the classification are not considered such as whether the message is formatted in html or not, if mispelled words are present, or if the message has words spelled in all uppercase characters among other things.

Removing English stop words decreased the observed accuracy of the classification based on the `training` set. In addition, stemming the words also decreased the observed accuracy of the classification based on the `training` set.

Below is observed classification on the `hold off` set. 

No removal of stop words or stemming used ( k= 0.5)

* ham:  696 ham / 4 spam
* spam: 57 ham / 193 spam 

Remove stop words (k = 0.5)

* ham:  693 ham / 7 spam
* spam: 67 ham / 183 spam

Stemming of words used (k = 0.5)

* ham:  696 ham / 4 spam
* spam: 61 ham / 189 spam

-----

### Convert to lowercase

Characters in plain text documents are converted to lowercase. 

```r
convert.lowercase <- function(doc){
  doc <- tm_map(doc, tolower)   
  doc <- tm_map(doc, PlainTextDocument)
  return(doc)
}
#TRAINING SET
ham_training <- convert.lowercase(ham_training)  
spam_training <- convert.lowercase(spam_training) 

#TESTING SET
ham_testing <- convert.lowercase(ham_testing)
hard_ham_testing <- convert.lowercase(hard_ham_testing)
spam_testing <- convert.lowercase(spam_testing)   

#HOLD OFF SET
ham_holdoff <- convert.lowercase(ham_holdoff)
spam_holdoff <- convert.lowercase(spam_holdoff)   

#inspect(ham_training[[1]])
```

-----

### Extract alpha characters only

This simplistic approach in text classification only looks at alpha characters. 


```r
extract.alpha <- function(docs){
  thispattern = "[a-z]+ |[a-z]+[a-z]$|[a-z]+[\\.|,|;] "
  for (j in seq(docs))
  {
    letters_only <- unlist(str_extract_all(docs[[j]], thispattern))
    docs[[j]] <- paste(letters_only, collapse = "   ")
  }
  #docs <- tm_map(docs, removeWords, stopwords("english"))
  #docs <- tm_map(docs, stemDocument, language = "english")  
  docs <- tm_map(docs, stripWhitespace)
  docs <- tm_map(docs, PlainTextDocument)
  docs <- tm_map(docs, removePunctuation)
  
  #inspect(docs[[1]])
  return(docs)
}
#TRAINING
ham_training <- extract.alpha(ham_training)
spam_training <- extract.alpha(spam_training)

#TESTING
ham_testing <- extract.alpha(ham_testing)
spam_testing <- extract.alpha(spam_testing)
hard_ham_testing <- extract.alpha((hard_ham_testing))

#HOLDOFF
ham_holdoff <- extract.alpha(ham_holdoff)
spam_holdoff <- extract.alpha(spam_holdoff)

#inspect(ham_training[[1]])
#inspect(spam_training[[1]])
#inspect(ham_testing[[1]])
#inspect(hard_ham_testing[[1]])
#inspect(spam_testing[[1]])
#inspect(ham_holdoff[[1]])
#inspect(spam_holdoff[[1]])
```

-----

### Create a term document matrix

This is the `training` set term document matrix. 

This is going to be used to generate the `training` set term frequency list. 

```r
ham_tdm <- TermDocumentMatrix(ham_training)
spam_tdm <- TermDocumentMatrix(spam_training)
```

-----

### Create the term frequency list

This is the term frequency list for the `training` set. 

Classification is going to depend on the term frequency list for `ham` and `spam` in the `training` set. 


```r
ham_freq <- rowSums(as.matrix(ham_tdm))
spam_freq <- rowSums(as.matrix(spam_tdm))

ham_termFreq <- cbind(names(ham_freq),ham_freq)
spam_termFreq <- cbind(names(spam_freq), spam_freq)

rownames(ham_termFreq) <- NULL
rownames(spam_termFreq) <- NULL

colnames(ham_termFreq) <- c("term", "frequency")
colnames(spam_termFreq) <- c("term", "frequency")

ham_termFreq <- data.frame(ham_termFreq, stringsAsFactors = FALSE)
spam_termFreq <- data.frame(spam_termFreq, stringsAsFactors = FALSE)

ham_termFreq$frequency <- as.numeric(ham_termFreq$frequency)
spam_termFreq$frequency <- as.numeric(spam_termFreq$frequency)

#head(ham_termFreq,10)
#head(spam_termFreq,10)
```

-----

### Calculate probability for each term in `training` set term frequency list

To calculate the conditional probability of the terms, *Laplace smoothing* was used. The value for `k` used is `0.5`. For the `training` set, k values of 0.1, 0.5, 1.5, and 2 were investigated. The classification was better (particularly for spam) when `k = 0.5`. 


<img src="C:/Users/stina/Documents/CUNY SPS Data Science/Spring 2018 Classes/DATA 607 - Data Acquisition and Management/Project 4/images/LaPlace-Smoothing.png" width="25%" />

`ham.UNKNOWN` and `spam.UNKNOWN` are conditional probabilities used when the term is <b>not found</b> in the training set. 

The marginal probability for `ham` and `spam` are based on the proportion of `ham` emails and `spam` emails in the entire training set. 


```r
ham_prob <- length(ham_training)/ (length(ham_training) + length(spam_training))
spam_prob <-  length(spam_training)/ (length(ham_training) + length(spam_training))

#Ham and spam marginal probability
ham_prob
```

```
## [1] 0.6463137
```

```r
spam_prob
```

```
## [1] 0.3536863
```

```r
#Laplace smoothing
k <- 0.5

#Total count of term occurrences in ham and spam
ham_N <- colSums(as.matrix(ham_termFreq$frequency)) 
spam_N <- colSums(as.matrix(spam_termFreq$frequency))

#Number of terms in ham
nrow(ham_termFreq)
```

```
## [1] 22238
```

```r
#Number of terms in spam
nrow(spam_termFreq)
```

```
## [1] 19400
```

```r
#Number of shared terms between ham and spam
nrow(as.data.frame(dplyr::intersect(ham_termFreq$term, spam_termFreq$term)))
```

```
## [1] 8073
```

```r
#Number of distinct vocabulary on both ham and spam
spamham_vocabulary <- nrow(as.data.frame(dplyr::union(ham_termFreq$term, spam_termFreq$term)))
spamham_vocabulary
```

```
## [1] 33565
```

```r
ham_termFreq$probability <- (ham_termFreq$frequency + k)/(ham_N + k*spamham_vocabulary)
spam_termFreq$probability <- (spam_termFreq$frequency + k)/(spam_N + k*spamham_vocabulary)

ham.UNKNOWN <- (0 + k)/(ham_N + k*spamham_vocabulary)
spam.UNKNOWN <- (0 + k)/(spam_N + k*spamham_vocabulary)
```

-----

### Preview `training - ham` term frequency and term conditional probability

<!--html_preserve--><div id="htmlwidget-fd4c494d7c68c6aa3e44" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-fd4c494d7c68c6aa3e44">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100"],["the","com","from","with","for","and","localhost","sep","net","esmtp","org","that","oct","aug","thu","this","mon","jalapeno","wed","you","tue","list","not","have","are","imap","fri","but","cvs","plain","was","they","bulk","all","can","has","about","will","smtp","use","just","your","one","more","get","bit","which","what","like","would","there","their","some","out","new","mailing","when","ascii","exim","other","sat","who","sun","people","only","any","message","time","been","friends","our","than","found","rohit","email","now","then","linux","khare","also","mail","into","them","its","users","had","how","think","could","were","rpm","microsoft","first","his","because","said","using","html","spam","even"],[24049,19790,18866,16410,16034,11265,10158,10009,9724,8707,6721,6080,5455,5176,4061,3792,3766,3652,3621,3347,3169,2732,2728,2709,2575,2433,2431,2422,2239,2186,2154,1673,1663,1576,1571,1571,1434,1398,1331,1321,1250,1234,1221,1201,1195,1175,1155,1128,1124,1118,1115,1108,1042,1014,1013,1008,954,947,937,937,929,920,889,878,875,861,854,851,844,838,810,802,786,765,764,762,751,744,736,733,719,705,689,682,676,674,660,644,643,641,640,636,633,629,623,614,614,594,593,591],[0.0426898160927089,0.0351297451249613,0.0334895700664502,0.0291299705602778,0.0284625400169875,0.0199971776208409,0.0180321626968454,0.0177676755932543,0.0172617774420902,0.0154565198289887,0.0119312085019291,0.0107933814321178,0.00968395566202098,0.00918870799824977,0.00720949242439707,0.00673199557294741,0.00668584346091138,0.00648348420044572,0.00642845668224892,0.00594208442463848,0.00562611996531491,0.00485040946686323,0.00484330914193461,0.00480958259852367,0.00457172171341491,0.00431966017844892,0.00431611001598461,0.00430013428489521,0.00397529441941087,0.00388121511410666,0.0038244125146777,0.0029705984420112,0.00295284762968965,0.00279841556249218,0.0027895401563314,0.0027895401563314,0.00254635402752618,0.00248245110316861,0.00236352066061423,0.00234576984829268,0.00221973908080969,0.00219133778109521,0.00216826172507719,0.0021327601004341,0.00212210961304117,0.00208660798839807,0.00205110636375497,0.00200317917048679,0.00199607884555817,0.00198542835816524,0.00198010311446878,0.00196767754584369,0.00185052218452147,0.00180081991002113,0.00179904482878898,0.0017901694226282,0.00169431503609184,0.00168188946746675,0.00166413865514521,0.00166413865514521,0.00164993800528797,0.00163396227419857,0.00157893475600177,0.00155940886244807,0.0015540836187516,0.00152923248150143,0.00151680691287635,0.00151148166917989,0.0014990561005548,0.00148840561316187,0.00143870333866154,0.0014245026888043,0.00139610138908982,0.00135882468321457,0.00135704960198241,0.0013534994395181,0.0013339735459644,0.00132154797733931,0.00130734732748207,0.00130202208378561,0.00127717094653544,0.00125231980928527,0.00122391850957079,0.00121149294094571,0.00120084245355278,0.00119729229108847,0.0011724411538383,0.00114403985412382,0.00114226477289167,0.00113871461042736,0.0011369395291952,0.00112983920426659,0.00112451396057012,0.0011174136356415,0.00110676314824857,0.00109078741715918,0.00109078741715918,0.00105528579251608,0.00105351071128393,0.00104996054881962]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>term<\/th>\n      <th>frequency<\/th>\n      <th>probability<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[2,3]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

-----

### Preview `training - spam` term frequency and term conditional probability

<!--html_preserve--><div id="htmlwidget-5eaafabfe415f349863a" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-5eaafabfe415f349863a">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100"],["font","the","com","for","and","from","you","with","your","net","this","jul","arial","esmtp","are","that","our","will","localhost","helvetica","may","have","img","email","table","not","mon","free","org","all","can","nbsp","click","tue","jun","mail","verdana","please","wed","html","get","thu","div","aug","input","smtp","new","business","more","out","one","list","span","microsoft","money","only","just","option","fri","internet","receive","how","any","sun","time","order","people","send","information","cfont","make","has","what","service","was","about","over","bit","address","home","want","they","now","credit","message","here","meta","sat","like","mailing","body","web","use","site","but","removed","times","who","form","printable"],[16137,14712,10552,10395,10357,10035,9121,8231,6692,5025,4882,4382,3140,3127,2920,2741,2577,2563,2469,2425,2418,2323,2234,2197,2031,2028,1945,1841,1817,1800,1781,1637,1611,1519,1451,1423,1405,1384,1377,1371,1354,1331,1298,1288,1272,1267,1254,1195,1192,1184,1114,1039,981,959,938,923,914,891,887,878,878,865,860,854,847,819,810,796,792,757,749,722,718,710,705,697,697,685,679,670,669,664,661,660,660,647,645,634,632,630,597,597,593,591,589,581,578,574,570,567],[0.0355640720779886,0.0324236350393436,0.0232557627019659,0.0229097636738485,0.0228260186861513,0.0221163901061908,0.0201021027705266,0.0181407070060396,0.0147490350043029,0.0110752746229547,0.0107601290113574,0.00965822127849947,0.00692108247008045,0.00689243286902614,0.00643624306762298,0.00604176009925985,0.00568033436288246,0.00564948094636244,0.00544232229258515,0.00534535441209366,0.00532992770383365,0.00512056523459065,0.00492442565814194,0.00484288448591046,0.00447705111860163,0.00447043967220449,0.00428752298855008,0.00405832618011563,0.00400543460893845,0.00396796974602129,0.00392609725217269,0.00360874782510961,0.003551448623001,0.00334869760015515,0.00319883814848647,0.00313713131544643,0.00309746263706355,0.00305118251228352,0.00303575580402351,0.00302253291122921,0.00298506804831204,0.00293438029260058,0.00286165438223196,0.0028396162275748,0.00280435518012335,0.00279333610279477,0.00276468650174046,0.00263466138926323,0.00262804994286608,0.00261041941914036,0.00245615233654025,0.00229086617661157,0.00216304487960005,0.0021145609393543,0.00206828081457427,0.00203522358258854,0.00201538924339709,0.00196470148768563,0.00195588622582277,0.00193605188663132,0.00193605188663132,0.00190740228557702,0.00189638320824844,0.00188316031545415,0.00186773360719414,0.00180602677415409,0.00178619243496265,0.00175533901844263,0.00174652375657977,0.00166939021527971,0.00165175969155399,0.00159225667397966,0.0015834414121168,0.00156581088839107,0.00155479181106249,0.00153716128733677,0.00153716128733677,0.00151071550174818,0.00149749260895388,0.00147765826976244,0.00147545445429672,0.00146443537696814,0.001457823930571,0.00145562011510528,0.00145562011510528,0.00142697051405098,0.00142256288311954,0.00139832091299667,0.00139391328206524,0.00138950565113381,0.00131677974076519,0.00131677974076519,0.00130796447890232,0.00130355684797089,0.00129914921703946,0.00128151869331373,0.00127490724691659,0.00126609198505372,0.00125727672319086,0.00125066527679371]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>term<\/th>\n      <th>frequency<\/th>\n      <th>probability<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"columnDefs":[{"className":"dt-right","targets":[2,3]},{"orderable":false,"targets":0}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->



--------------

### Create document term matrix for `hold off` and `testing` sets

This is the term document matrix (tdm) for the `hold off` and `testing` sets. 


```r
#HOLD OFF SET
ham_holdoff_dtm <- DocumentTermMatrix(ham_holdoff)
spam_holdoff_dtm <- DocumentTermMatrix(spam_holdoff)

#TESTING SET
ham_testing_dtm <- DocumentTermMatrix(ham_testing)
spam_testing_dtm <- DocumentTermMatrix(spam_testing)
hard_ham_testing_dtm <- DocumentTermMatrix(hard_ham_testing)

#CONVERT AS MATRIX
ham_holdoff_dtm <- as.data.frame(as.matrix(ham_holdoff_dtm))
spam_holdoff_dtm <- as.data.frame(as.matrix(spam_holdoff_dtm))
ham_testing_dtm <- as.data.frame(as.matrix(ham_testing_dtm))
spam_testing_dtm <- as.data.frame(as.matrix(spam_testing_dtm))
hard_ham_testing_dtm <- as.data.frame(as.matrix(hard_ham_testing_dtm))
```

-----

### Functions to help calculate `ham` and `spam` scores

The terms in the tdm will be used to generate a `ham.score` and `spam.score` for each document. The score for each term is based on the frequency of that term in the `training` set. If a term is *not present* in the `training` set, the conditional probability of `ham.UNKNOWN` and `spam.UNKNOWN` are assigned to the term to generate the `ham.score` and `spam.score`.   


```r
##Get conditional probability of a term in the ham training set. 
get.ham.probability <-function(term){
  result <- ham_termFreq$probability[ham_termFreq$term == term]
  if(length(result)==0){return(ham.UNKNOWN)}
  return(result)
}
##Get conditional probability of a term in the spam training set. 
get.spam.probability <- function(term){
  result <- spam_termFreq$probability[spam_termFreq$term == term]
  if(length(result)==0){return(ham.UNKNOWN)}
  return(result)
}
##Return classification of ham or spam based on maximum score. 
get.spamham <- function(ham.score, spam.score){
  if(ham.score == spam.score){return("same score")}
  if(ham.score > spam.score){return("ham")}
  return("spam")
}
##Classify a document as either spam or ham.
doc.classify <- function(dtm, i){
    doc <- t(dtm[i,1:ncol(dtm)]) #transpose
    doc <- as.data.frame(doc)
    colnames(doc) <- c("count")
    doc_result <- NULL
    doc_result$terms <- rownames(doc)[which(doc$count > 0)]
    doc_result$count <- doc[which(doc$count > 0),1]
    doc_result <- as.data.frame(doc_result)
    
    doc_result$ham.probability.log <- 
      log(sapply(doc_result$terms, get.ham.probability))* doc_result$count
    
    doc_result$spam.probability.log <- 
      log(sapply(doc_result$terms, get.spam.probability))* doc_result$count
    
    doc_ham.score <- colSums(as.data.frame(doc_result$ham.probability.log)) + log(ham_prob)
    doc_spam.score <- colSums(as.data.frame(doc_result$spam.probability.log)) + log(spam_prob)
    doc_class <- get.spamham(doc_ham.score, doc_spam.score)
    return(c(doc_ham.score, doc_spam.score, doc_class))
}
##Classify all the documents in the dtm as either spam or ham. 
dtm.classify <- function(dtm){
    docs_classification <- as.data.frame(NULL)
    for(i in 1:nrow(dtm)){
    #for(i in 1:100){ 
      result <- doc.classify(dtm,i)
      docs_classification[i,1] <- result[1]
      docs_classification[i,2] <- result[2]
      docs_classification[i,3] <- result[3]
    }
    colnames(docs_classification) <- c("ham.score", "spam.score", "classification")
    return(docs_classification)
}
```

-------------------

### Classify documents in document term matrix as either `ham` or `spam`

For each document, a `ham.score` and `spam.score` are calculated. 

`ham.score` is calculated based on `log(P(spam)xP(term_1|spam)x...xP(term_n|spam))`.

`spam.score` is calculated based on  `log(P(ham)xP(term_1|ham)x...xP(term_n|ham))`.

The log is used to generate the scores because multiplying the probabilities for all the terms present in the document produces a very small number that is very close to zero.


```r
#HOLD OFF SET
holdoff_ham_classification <- dtm.classify(ham_holdoff_dtm)
holdoff_spam_classification <- dtm.classify(spam_holdoff_dtm)

#TESTING SET
testing_ham_classification <- dtm.classify(ham_testing_dtm)
testing_spam_classification <- dtm.classify(spam_testing_dtm)
testing_hard_ham_classification <- dtm.classify(hard_ham_testing_dtm)
```

-----

### Preview `ham.score` and `spam.score`

This is a preview of the first 100 emails in the `ham` `hold off` set. 

```r
datatable(holdoff_ham_classification[1:100,])
```

<!--html_preserve--><div id="htmlwidget-5b96d99d617002ec5f27" style="width:100%;height:auto;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-5b96d99d617002ec5f27">{"x":{"filter":"none","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100"],["-5456.12313155888","-1325.09038648553","-1656.92422526979","-5927.0895352421","-961.859643306778","-5821.72842791274","-1343.86527942705","-2178.87561374837","-1539.96239651522","-987.925227948896","-624.08494531924","-1449.52268088147","-659.202489075532","-2586.42155906306","-1473.31085868217","-2586.42155906306","-2251.56818302653","-840.803703076336","-626.751300560599","-1479.53363736552","-953.231156105781","-1610.5905994227","-1013.41407357761","-892.485240381106","-1686.86679030731","-1191.41781139273","-1625.27550729219","-1438.18517759437","-1570.7234289555","-1349.18330103551","-774.591797905756","-2339.37664260434","-957.652693291831","-1408.87721302301","-1418.40700234623","-1562.05471112445","-1137.32525660176","-1327.12636207237","-1242.86005207803","-1093.98078584958","-606.735936286133","-2697.34115426612","-1517.38481550166","-1050.20655184211","-3464.67685731545","-1073.11982357774","-3662.44113622294","-796.220282150783","-1270.52831499767","-998.281936850432","-948.351821744654","-944.540847369151","-929.665527885615","-1244.76107083417","-5386.55001959069","-5943.47549747285","-700.880320322742","-1029.10024912517","-1124.965239204","-2394.22279433069","-1436.40155696426","-1235.21828703282","-1206.76671160848","-1432.183898072","-2289.80932580828","-616.636622870254","-1136.95813007587","-933.228460592212","-1403.63774831616","-1090.29093807679","-1173.64413436498","-1944.17006150225","-1981.30258946965","-1402.65561556929","-1410.75731859772","-942.338225617667","-1849.83960393116","-1641.5312458221","-1310.04545316952","-874.057270370263","-1481.99323441639","-1504.58483528165","-955.988924234184","-1958.40930032182","-1938.23462808387","-1619.5259558736","-1557.80122007316","-1812.46193857201","-767.509683096176","-933.976128400221","-1160.1648247003","-1476.6657045411","-1215.34697526281","-1348.81307990452","-1607.67493304195","-1540.10887572735","-1761.8067956775","-1844.92795489857","-2352.06496628151","-2629.15445755516"],["-6090.79747576783","-1582.48642449215","-1962.69314442382","-6678.3056934998","-1160.44630981357","-6513.68855219441","-1643.24548425438","-2550.69238469613","-1812.82049283655","-1200.03235426162","-746.60871511921","-1749.10328862898","-773.922756239643","-2745.9315143606","-1569.58498124689","-2745.9315143606","-2488.80086789207","-938.21271963677","-706.862448454982","-1616.13614881641","-1048.24220401932","-1792.99200416277","-1139.44710802265","-989.601217819219","-1846.41248658329","-1332.52978457751","-1682.52317346969","-1493.35842302085","-1614.52991940386","-1412.57421174926","-807.148577608576","-2455.55128997625","-974.096047576149","-1469.23000129308","-1465.58255939504","-1600.44615275987","-1181.19792275561","-1368.10808269381","-1289.89564643212","-1146.28644159586","-616.159234532338","-2813.74165964374","-1636.20004724768","-1138.33984998432","-3574.52487681119","-1162.51765781333","-3821.76449466878","-874.978693140113","-1367.80706649253","-1089.63932033024","-1032.83703110102","-1017.49150339643","-1019.44813152097","-1358.24411997097","-5569.05676970533","-6152.05043393909","-777.499051795773","-1073.63242601763","-1176.85043552779","-2494.8242731802","-1488.71907156394","-1288.5182530684","-1277.76250185416","-1489.63451372435","-2393.5300858142","-652.152082617022","-1180.45737037801","-985.997611399685","-1512.37480927922","-1137.34577954159","-1214.46890615838","-2052.68462470821","-2088.02730358077","-1449.42162134929","-1473.67635826384","-987.25056134315","-1953.99536009761","-1715.32915099858","-1367.23975064657","-903.410327408525","-1581.11730960816","-1590.84631094724","-1005.07881842726","-1955.37994035963","-2023.17196876215","-1704.88676919324","-1633.09005897616","-1837.00376524068","-804.086627367396","-994.815778726563","-1196.49341112473","-1540.05928574961","-1244.2731379558","-1392.87327911313","-1681.26699841134","-1623.67276883837","-1856.94552126686","-1909.6980377713","-2477.50457053645","-2783.52747858552"],["ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","spam","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham","ham"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>ham.score<\/th>\n      <th>spam.score<\/th>\n      <th>classification<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"order":[],"autoWidth":false,"orderClasses":false,"columnDefs":[{"orderable":false,"targets":0}]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->

-----

### Prepare classification results for display

This prepares a data frame that contains results data of the classification. 

```r
get.Info <- function(label, classification){
  #classification <- holdoff_ham_classification
  c(
    label,
    nrow(classification),
    nrow(classification[classification$classification=="ham",]),
    nrow(classification[classification=="spam",]),
    round(nrow(classification[classification=="ham",])/
      nrow(classification),2),
    round(nrow(classification[classification$classification=="spam",])/
      nrow(classification),2)
  )
}

classification_results <- 
rbind(
  get.Info("Hold off - Easy Ham", holdoff_ham_classification),
  get.Info("Hold off - Spam", holdoff_spam_classification),
  get.Info("Testing - Easy Ham", testing_ham_classification),
  get.Info("Testing - Spam", testing_spam_classification),
  get.Info("Testing - Hard Ham",testing_hard_ham_classification)
)
colnames(classification_results) <-
  c("Set", "Total Emails","Ham", "Spam", "Ham %", "Spam %")
```

-----

###Classification results

For the `hold off` set, `ham` emails were classified as `ham` at 99% while `spam` emails were classified as `spam` only at 77%.

For the `testing` set, the *easy ham* `ham` emails were classified as `ham` at 98% while `spam` emails were classified as `spam` only at 68%. 

Because there is a *hard ham* set available, I decided to run this against the `training` set, which is based on the *easy ham* data. As expected, the classification for the the *hard ham* did really poorly. Only 28% of the *hard ham* emails were classified as `ham` and the rest were incorrectly classified as `spam`. 



|Set                 |Total Emails |Ham |Spam |Ham % |Spam % |
|:-------------------|:------------|:---|:----|:-----|:------|
|Hold off - Easy Ham |700          |696 |4    |0.99  |0.01   |
|Hold off - Spam     |250          |57  |193  |0.23  |0.77   |
|Testing - Easy Ham  |701          |690 |11   |0.98  |0.02   |
|Testing - Spam      |251          |81  |170  |0.32  |0.68   |
|Testing - Hard Ham  |250          |70  |180  |0.28  |0.72   |





-----

### Classification of `spam` and `ham` emails in the `hold off` set

![](Data607-Project4_files/figure-html/unnamed-chunk-22-1.png)<!-- -->

-----

### Classification of `spam` and `ham` emails in the `testing` set

The `training` set used the *easy ham* data. The `ham` emails in this `testing` set is classified as *easy ham*. 

![](Data607-Project4_files/figure-html/unnamed-chunk-23-1.png)<!-- -->

-----

### Classification of *hard ham* emails 

The `training` set used *easy ham* data. As you can see, classifying the *hard ham* emails on a `training` set that only looked at *easy ham* emails produced <b>poor results</b>. Majority of the *hard ham* emails were classified as `spam`. 

![](Data607-Project4_files/figure-html/unnamed-chunk-24-1.png)<!-- -->
--------------

