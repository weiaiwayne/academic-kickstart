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

review_corpus_byuser <- corpus(reviews,docid_field = "reviewer_name",text_field = "comments")
reviewer_corpus <- corpus(review_corpus_byuser,docid_field = "reviewer_name",text_field = "comments")

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
reviews_bycity_dfm <- dfm(review_corpus_bycity)
###

### CONCEPT 3: TOKENIZATION
### Challenge 3: Tokenize the 10th review by words. Remove punctuation, numbers, 
### symbols, urls, and Twitter handles. Also remove stop words and two additional
### words: "highly" and "recommend."
review_corpus[1]
tokens(review_corpus[1])


tokens(review_corpus[5],what = "sentence")

reviews_tok <- tokens(review_corpus[5],remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)
reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')
reviews_tok <- tokens_select(reviews_tok, pattern = c("lockbox","guests","however"), selection = 'remove')

### WORK ZONE
reviews_tok <- tokens(review_corpus[10],remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)
reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')
reviews_tok <- tokens_select(reviews_tok, pattern = c("highly","recommend"), selection = 'remove')

###

### CONCEPT 4: CREATE N-GRAMS
### Challenge 4: Create bigram (n=2) 

#tokenize into n-grams
toks_ngram <- tokens_ngrams(reviews_tok, n = 3) 
#convert the tokenized corpus into a dfm
dfm1 <- dfm(toks_ngram,remove = stopwords("english"),stem = FALSE, remove_punct = TRUE)
#create wordcloud from the dfm
textplot_wordcloud(dfm1, max_words = 100)

### WORK ZONE
toks_ngram <- tokens_ngrams(reviews_tok, n = 2) 
###

### CONCEPT 5: CREATE SEMANTIC NETWORKS
### Challenge 5: create a semantic network with 120 features

dfm1 <- dfm(review_corpus,remove = stopwords("english"),stem = FALSE, remove_punct = TRUE)
dfm1 <- dfm_trim(dfm1, min_termfreq = 10)
fcm1 <- fcm(dfm1) #create a feature co-occurrence network
feat <- names(topfeatures(dfm1, 80)) #get the top 100 features (terms)
selected_dfm <- fcm_select(fcm1, pattern = feat) #create a new dfm containing only the top features
textplot_network(selected_dfm, min_freq = 0.8)

### WORK ZONE
dfm1 <- dfm(review_corpus,remove = stopwords("english"),stem = FALSE, remove_punct = TRUE)
dfm1 <- dfm_trim(dfm1, min_termfreq = 10)
fcm1 <- fcm(dfm1) #create a feature co-occurrence network
feat <- names(topfeatures(dfm1, 120)) #get the top 100 features (terms)
selected_dfm <- fcm_select(fcm1, pattern = feat) #create a new dfm containing only the top features
textplot_network(selected_dfm, min_freq = 0.8)

###

### CONCEPT 6: TOPIC MODELS
### Challenge 6: apply a topic model to the corpus in which a reviewer's reviews is a document
dfm1 <- dfm(review_corpus,remove = stopwords("english"),stem = FALSE, remove_punct = TRUE)
dtm1 <- convert(dfm1, to = "topicmodels")
lda <- LDA(dtm1, k = 3)
terms(lda, 25)

### WORK ZONE
dfm1 <- dfm(reviewer_corpus,remove = stopwords("english"),stem = FALSE, remove_punct = TRUE)
dtm1 <- convert(dfm1, to = "topicmodels")
lda <- LDA(dtm1, k = 3)
terms(lda, 25)
###

