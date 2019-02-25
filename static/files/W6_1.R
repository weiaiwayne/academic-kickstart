library(quanteda)
library(readr)
library(dplyr)
library(topicmodels)
library(ggplot2)

### CONCEPT 1: CORPUS
### Challenge 1: Create a corpus in which reviews by the same user will be treated as a document

## code reference
reviews <- read.csv("https://curiositybits.cc/files/airbnb_reviews_2018_sample.csv")
reviews<- reviews[,2:8]
reviews$comments <- as.character(reviews$comments)

review_corpus <- corpus(reviews,docid_field = "id",text_field = "comments")
review_corpus

reviews_bycity <- aggregate(comments~city, data = reviews, paste0, collapse=". ")

#create a corpus based on the new data frame
review_corpus_bycity <- corpus(reviews_bycity,docid_field = "city",text_field = "comments")

review_corpus_bycity

### WORK ZONE

###

### CONCEPT 2: DFM
### Challenge 2: Create a DFM based on the corpus in which a document refers to all reviews from the same city
reviews_dfm <- dfm(review_corpus)
reviews_dfm[1:8,1:8]
reviews_dfm[1:8,"great"]

reviews_dfm %>% 
  textstat_frequency(n = 25) %>% 
  ggplot(aes(x = reorder(feature, frequency), y = frequency)) +
  geom_point() +
  coord_flip() +
  labs(x = NULL, y = "Frequency") +
  theme_minimal()

### WORK ZONE

###

### CONCEPT 3: TOKENIZATION
### Challenge 3: Tokenize the 10th review by words. Remove punctuation, numbers, 
### symbols, urls, and Twitter handles. Also remove stop words and two additional
### words: "highly" and "recommend."

tokens(review_corpus[5])
tokens(review_corpus[5],what = "sentence")

reviews_tok <- tokens(review_corpus[5],remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)
reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')
reviews_tok <- tokens_select(reviews_tok, pattern = c("lockbox","guests","however"), selection = 'remove')

reviews_tok
