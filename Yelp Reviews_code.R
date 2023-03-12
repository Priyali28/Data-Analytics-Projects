---
  output: 
title: "Assignment-Yelp reviews- Text Mining and Sentiment Analysis"
name: "Submitted by: Priyali Tambe"
date: "April 10, 2022"
---

knitr::opts_chunk$set(echo = TRUE)

# let us first install and add required packages
install.packages('expss')
install.packages("cowplot")
install.packages("gridExtra")
library("cowplot")
library("gridExtra")
library('tidyverse')
library('tidyverse')
library(ggplot2)
library(caret)
library(tidytext)
library(SnowballC)
library(textstem)
library(tidyverse)
library(textdata)
library(e1071)  # for the naiveBayes function
library(rsample)
library(pROC)
# install.packages("dplyr")
# install.packages("magrittr")
library(magrittr)
library(dplyr)
library('expss')

#Question 1: Explore the data.
# a) How are star ratings distributed? How will you use the star ratings to obtain a label indicating 'positive' or 'negative' - explain using the data, graphs, etc.?Do star ratings have any relation to 'funny', 'cool', 'useful'? Is this what you expected?

#the purpose is get a basic idea on the yelp dataset 

#We will use the read_csv2 function to read our csv file
resReviewsData <- read_csv2('yelp.csv')

#number of reviews by star rating
resReviewsData %>% group_by(starsReview) %>% count()

#distribution of reviews across star ratings
ggplot(resReviewsData, aes(x=starsReview)) + geom_bar(width = 0.4, color="darkblue", fill="lightblue") + xlab("Ratings") + ylab("No of Reviews")

#reviews from various states 
resReviewsData %>%   group_by(state) %>% tally() %>% view()

#Distribution of reviews across states
ggplot(resReviewsData, aes(x=state)) + geom_bar(width = 0.4, color="darkblue", fill="lightblue") + xlab("Name of States") + ylab("No of Reviews")

#Distribution of reviews across postal codes
resReviewsPostal <- resReviewsData %>% group_by(postal_code) %>% count() %>% arrange(desc(n))
resReviewsPostal <- ungroup(resReviewsPostal)
postal_code_top <- resReviewsPostal %>% top_n(10)
#to keep only the those reviews from 5-digit postal-codes
rrData<-resReviewsData%>% filter(str_detect(postal_code, "^[0-9]{1,5}"))

#Distribution of reviews across top 10 postal code
ggplot(postal_code_top, aes(x=postal_code,y=n)) + geom_bar(width = 1, color="darkblue", fill="lightblue") + xlab("Postal Code") + ylab("No of Reviews")

#positive and negative sentiment
resReviewsData$sentiment<-ifelse(resReviewsData$starsReview>=3,"Positive","Negative")
resReviewsData%>%group_by(sentiment)%>%tally()%>%view()

#Relation of Star ratings to word 'funny', 'cool' and 'useful'
ggplot(resReviewsData, aes(x= funny, y=starsReview)) +geom_point()
line_graph <- resReviewsData %>% group_by(starsReview) %>% summarize(mean(funny))
ggplot(line_graph) + aes(x=starsReview, y=line_graph$`mean(funny)`, fill=line_graph$starsReview) + geom_line() + xlab("Ratings") + ylab("Average of 'Funny'")

ggplot(resReviewsData, aes(x= cool, y=starsReview)) +geom_point()
line_graph1 <- resReviewsData %>% group_by(starsReview) %>% summarize(mean(cool))
ggplot(line_graph1) + aes(x=line_graph1$starsReview, y=line_graph1$`mean(cool)`, fill=line_graph1$starsReview) + geom_line() + xlab("Ratings") + ylab("Average of 'Cool'")

ggplot(resReviewsData, aes(x= useful, y=starsReview)) +geom_point()
line_graph2 <- resReviewsData %>% group_by(starsReview) %>% summarize(mean(useful))
ggplot(line_graph2) + aes(x=line_graph2$starsReview, y=line_graph2$`mean(useful)`, fill=line_graph2$starsReview) + geom_line() + xlab("Ratings") + ylab("Average of 'Useful'")

#to find correlation
ggplot(resReviewsData, aes(x= cool, y=funny)) +geom_point()
ggplot(resReviewsData, aes(x= cool, y=useful)) +geom_point()
ggplot(resReviewsData, aes(x= useful, y=funny)) +geom_point()

#Question1)b) Relation of star ratings to business stars?
ggplot(resReviewsData, aes(x= starsBusiness, y=starsReview), main =("Star Ratings vs. Business Stars")) + geom_point() + xlab("Business Stars") + ylab("Ratings")
stars%>% group_by(starsReview) %>%summarize(mean(starsBusiness))

# to find relation between business stars and star ratings
resReviewsData%>%group_by(business_id,starsBusiness)%>% summarize(starsAverage=round(mean(starsReview),1))
resReviewsData%>%group_by(business_id,starsBusiness)%>% summarize(starsAverage=round(mean(starsReview),1))%>%view()

p<-list()
i<-1
for(r in c(1.5,2,2.5,3,3.5,4,4.5,5)){
  tbl_=resReviewsData[resReviewsData$starsBusiness==r,]
  p[[i]]<-ggplot(tbl_, aes(x=starsReview))+geom_bar()+ggtitle(paste("starsBusiness:",r))
  i<-i+1
}
do.call(grid.arrange,p)
?grid()
?do.call

resReviewsData<-resReviewsData[,c("starsReviews","starsBusiness","count")]%>%pivot_wider(names_from=starsReview, values_from=count,values_fn = sum, values_fill =0 )
resReviewsData<-resReviewsData%>%remove_rownames%>%column_to_rownames(var="starsBusiness")
resReviewsData<-prop_col(resReviewsData)
resReviewsData<-tibble::rownames_to_column(resReviewsData,"starsBusiness")
resReviewsData<-resReviewsData%>%pivot_longer(!starsBusiness,names_to = "starsReview",values_to = "count")
resReviewsData<-data.frame(resReviewsData)
ggplot(resReviewsData, aes(fill=starsReview, y=count, x=starsBusiness)) +
  geom_bar(position = "dodge", stat="identity") + theme(axis.text.x = element_text(angle=90, vjust=0.5, hjust=1))

#Question 2: What are some words indicative of positive and negative sentiment? (One approach is to determine
#the average star rating for a word based on star ratings of documents where the word occurs). Do
#these 'positive' and 'negative' words make sense in the context of user reviews being considered?
#(For this, since we'd like to get a general sense of positive/negative terms, you may like to consider a
#pruned set of terms -- say, those which occur in a certain minimum and maximum number of
#documents). 
#Use tidytext for tokenization, removing stopworks, stemming/lemmatization, etc.


#tokenize the text of the reviews in the column named 'text'
rrTokens <- rrData %>% unnest_tokens(word, text)
# this will retain all other attributes
#Or we can select just the review_id and the text column
#rrTokens <- rrData %>% select(review_id, starsReview, text ) %>% unnest_tokens(word, text)

#Dimensions for the distinct token words
rrTokens %>% distinct(word) %>% dim()


#remove stopwords
rrTokens <- rrTokens %>% anti_join(stop_words)
#compare with earlier - what fraction of tokens were stopwords?
rrTokens %>% distinct(word) %>% dim()


#count the total occurrences of differet words, & sort by most frequent
rrTokens %>% count(word, sort=TRUE) %>% top_n(10)

#Are there some words that occur in a large majority of reviews, or which are there in very few reviews?   Let's remove the words which are not present in at least 10 reviews
rareWords <-rrTokens %>% count(word, sort=TRUE) %>% filter(n<10)
rareWords %>% distinct(word) %>% dim()
xx<-anti_join(rrTokens, rareWords)

#check the words in xx .... 
xx %>% count(word, sort=TRUE) %>% view()
#you willl see that among the least frequently occurring words are those starting with or including numbers (as in 6oz, 1.15,...).  To remove these
xx2<- xx %>% filter(str_detect(word,"[0-9]")==FALSE)
#the variable xx, xx2 are for checking ....if this is what we want, set the rrTokens to the reduced set of words.  And you can remove xx, xx2 from the environment.
rrTokens<- xx2

#Analyze words by star ratings 

#Check words by star rating of reviews
rrTokens %>% group_by(starsReview) %>% count(word, sort=TRUE)
#or...
rrTokens %>% group_by(starsReview) %>% count(word, sort=TRUE) %>% arrange(desc(starsReview)) %>% view()

#proportion of word occurrence by star ratings
ws <- rrTokens %>% group_by(starsReview) %>% count(word, sort=TRUE)
ws<-  ws %>% group_by(starsReview) %>% mutate(prop=n/sum(n))

#check the proportion of 'love' among reviews with 1,2,..5 starsReview 
ws %>% filter(word=='love')

#what are the most commonly used words by start rating
ws %>% group_by(starsReview) %>% arrange(starsReview, desc(prop)) %>% view()

#to see the top 20 words by star ratings
ws %>% group_by(starsReview) %>% arrange(starsReview, desc(prop)) %>% filter(row_number()<=20) %>% view()

#To plot this
ws %>% group_by(starsReview) %>% arrange(starsReview, desc(prop)) %>% filter(row_number()<=20) %>% ggplot(aes(word, prop))+geom_col()+coord_flip()+facet_wrap((~starsReview))

#Or, separate plots by starsReview
ws %>% filter(starsReview==1)  %>%  ggplot(aes(word, n)) + geom_col()+coord_flip()


#Can we get a sense of which words are related to higher/lower star ratings in general? 
#One approach is to calculate the average star rating associated with each word - can sum the star ratings associated with reviews where each word occurs in.  Can consider the proportion of each word among reviews with a star rating.
xx<- ws %>% group_by(word) %>% summarise(totWS=sum(starsReview*prop))

#What are the 20 words with highest and lowerst star rating
xx %>% top_n(20)
xx %>% top_n(-20)
#Q - does this 'make sense'?

#Stemming and Lemmatization

#rrTokens_stem<-rrTokens %>%  mutate(word_stem = SnowballC::wordStem(word))
rrTokens_lemm<-rrTokens %>%  mutate(word_lemma = textstem::lemmatize_words(word))
#Check the original words, and their stemmed-words and word-lemmas

#Term-frequency, tf-idf

#tokenize, remove stopwords, and lemmatize (or you can use stemmed words instead of lemmatization)
rrTokens<-rrTokens %>%  mutate(word = textstem::lemmatize_words(word))

#Or, to you can tokenize, remove stopwords, lemmatize  as
#rrTokens <- resReviewsData %>% select(review_id, starsReview, text, ) %>% unnest_tokens(word, text) %>%  anti_join(stop_words) %>% mutate(word = textstem::lemmatize_words(word))

#We may want to filter out words with less than 3 characters and those with more than 15 characters
rrTokens<-rrTokens %>% filter(str_length(word)<=3 | str_length(word)<=15)
rrTokens<- rrTokens %>% group_by(review_id, starsReview) %>% count(word)

#count total number of words by review, and add this in a column
totWords<-rrTokens  %>% group_by(review_id) %>%  count(word, sort=TRUE) %>% summarise(total=sum(n))
xx<-left_join(rrTokens, totWords)
# now n/total gives the tf values
xx<-xx %>% mutate(tf=n/total)
head(xx)

#We can use the bind_tfidf function to calculate the tf, idf and tfidf values
rrTokens<-rrTokens %>% bind_tf_idf(word, review_id, n)
head(rrTokens)

#Sentiment analysis using the 3 sentiment dictionaries available with tidytext (use library(textdata))

# Question: 3 a) How many matching terms are there for each of the dictionaries?Consider using the dictionary based positive and negative terms to predict sentiment (positive or negative based on star rating) of a movie. One approach for this is: using each dictionary, obtain an aggregated positiveScore and a negativeScore for each review; for the AFINN dictionary, an aggregate positivity score can be obtained for each review. Describe how you obtain predictions based on aggregated scores. Are you able to predict review sentiment based on these aggregated scores, and how do they perform? Does any dictionary perform better?
#Matching Terms for each Dictionary- Part 1
rrSenti_bing1 <- rrTokens %>% inner_join(get_sentiments("bing"), by="word") 
rrSenti_nrc1<- rrTokens %>% inner_join(get_sentiments("nrc"), by="word") 
rrSenti_affin1<- rrTokens %>% inner_join(get_sentiments("afinn"), by="word") 

binn<- nrow(rrSenti_bing1)
nrcn <- nrow(rrSenti_nrc1)
affn <- nrow(rrSenti_affin1)

table_terms <- matrix(c(binn,nrcn,affn),ncol=3,byrow=TRUE)
colnames(table_terms) <- c("Bing","NRC","AFFIN")
rownames(table_terms) <- c("Number of terms")
table_terms <- as.table(table_terms)%>%view()
barplot(table_terms, color="darkblue", fill="lightblue", main =" Matching terms in each dictionary")

#b)What is the overlap in matching terms between the different dictionaries? Based on this, 
#do you think any of the three dictionaries will be better at picking up sentiment information from you text of reviews?
rrSenti_bing1_semi <- rrTokens %>% semi_join(get_sentiments("bing"), by="word") 
rrSenti_nrc1_semi<- rrTokens %>% semi_join(get_sentiments("nrc"), by="word") 
rrSenti_affin1_semi<- rrTokens %>% semi_join(get_sentiments("afinn"), by="word") 

binn1<- nrow(rrSenti_bing1_semi)
nrcn1 <- nrow(rrSenti_nrc1_semi)
affn1 <- nrow(rrSenti_affin1_semi)

table_terms_semi <- matrix(c(binn1,nrcn1,affn1),ncol=3,byrow=TRUE)
colnames(table_terms_semi) <- c("Bing","NRC","AFFIN")
rownames(table_terms_semi) <- c("Number of terms")
table_terms <- as.table(table_terms_semi)%>%view()
barplot(table_terms_semi, color="darkblue", fill="lightblue", main =" Overlap in Matching terms in each dictionary")
