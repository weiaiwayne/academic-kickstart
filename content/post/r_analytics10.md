+++
title = "From corpus to document-feature matrix"
date = 2019-02-25T16:42:42-05:00
draft = false

# Tags and categories
# For example, use `tags = []` for no tags, or the form `tags = ["A Tag", "Another Tag"]` for one or more tags.
tags = ["social media", "computational","data science","COMM497","R", "automation"]
categories = []

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder. 
[image]
  # Caption (optional)
  caption = ""

  # Focal point (optional)
  # Options: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight
  focal_point = ""
+++

This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-text-mining-from-corpus-to-dfm) on using R for social data analytics.

## Text mining: From corpus to DFM

There is a lot of interest in quantifying and visualizing textual data.
Texts reveal [our thoughts](https://blogs.wsj.com/numbers/mining-tweets-for-public-opinion-1118/), [our personality](https://wordwatchers.wordpress.com/), and
[the pulse of a society](http://theconversation.com/how-twitter-gives-scientists-a-window-into-human-happiness-and-health-62255). We broadly refer to the
_quantification of text_ as _text mining_. Thanks to the developments in
[Natural Language Processing](https://en.wikipedia.org/wiki/Natural_language_processing) and [Information retrieval](https://en.wikipedia.org/wiki/Information_retrieval), we now have a wide selection of easy-to-use R libraries for cleaning, transforming, quantifying, and visualizing text. 

**Which R library?**

Throughout the tutorials on text mining, we will use the library *quantaeda*, which stands for Quantitative Analysis of Textual Data. You can visit the [library website](https://quanteda.io/) to view many examples. 

There is another decent text mining library called *tidytext*. Although we will not use it since there is a considerable overlap in functionality between the two libraries, I still highly recommend checking out [tidytext](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html) and [a free e-book](https://www.tidytextmining.com/) written by the library author.

**What data?**

You might get a wrong impression that the codes we have implemented so far only apply to Twitter data. Not at all. You can use the codes on any sort of data (e.g., Facebook posts, Reddit posts, news articles, Wikipedia entries, your personal texts/emails, etc.). In this tutorial, we will analyze Airbnb reviews in 2018 from three cities: Boston, Denver, and Rhode Island. The [data are shared](http://insideairbnb.com/get-the-data.html) by the company Airbnb. The original datasets are enormous. But in our example, we will deal with randomly selected 9,000 reviews.

**Workflow**

A typical workflow in text mining is: 

1. **create a corpus from text files**; 
2. **tokenization**;
3. **create a DFM**; 
4. **conduct a variety of text analyses**. 

**Text file**

Text mining typically begins with text files (e.g., a data frame or a CSV file) containing character strings (the actual text) and the metadata of the text. Take a look at the example below (a data frame named _reviews_).  

```sh
library(quanteda)
library(readr)
library(dplyr)
library(topicmodels)

reviews <- read.csv("https://curiositybits.cc/files/airbnb_reviews_2018_sample.csv")
head(reviews)
```

The _reviews_ dataframe has a column called _comments_, which contains Airbnb users' reviews. Along with it are metadata such as _date_, _city_, and etc. 

**Corpus**

Think of a _corpus_ as a container of different *documents*. A *corpus* is the complete collection of text you want to analyze, *Documents* are individual units in that collection. For example, if you want to analyze someone's tweets (the corpus), each unique tweet can be treated as a document. Another example is: if you want to compare tweets sent by GOP and the Democratic Party, you can treat all tweets sent by one party as a single document. This treatment will lead you to have two documents in the corpus. 

Let's put the idea to test. Run the code below. The code will create a corpus of Airbnb reviews, which contains 9,000 documents (i.e., 9,000 reviews). In this example, each review has an unique id (the _id_ column), the ids are used as the document IDs (docid_field = "id"); we specify the _comments_ column as the text field so that R knows where to extract character strings. 

```sh
review_corpus <- corpus(reviews,docid_field = "id",text_field = "comments")
review_corpus
```
The output shows that there are 9,000 documents in the corpus we have just created. Next, let's test a bolder idea: creating a corpus in which reviews from each city will be combined and treated as a document. 

```sh
#create a new data frame with three rows, each containing reviews from a respective city
reviews_bycity <- aggregate(comments~city, data = reviews, paste0, collapse=". ")

#create a corpus based on the new data frame
review_corpus_bycity <- corpus(reviews_bycity,docid_field = "city",text_field = "comments")

review_corpus_bycity
```


Yes. the corpus created from the above step contains three documents, for Boston, Denver, and Rhode Island, respectively. We first create a new data frame (called reviews_bycity) by using aggregate() to merge reviews from the same city. Then, in corpus(), we specify *docid_field = "city"*. This tells R to recognize the city column as the document IDs. 

**DFM**

With a corpus, we can go ahead and create a DFM (document feature matrix). What is a DFM? The best way to understand it is perhaps by playing around one. 

Run the code below. It will construct a DFM based on the corpus of 9,000 documents. 

```sh
review_corpus <- corpus(reviews,docid_field = "id",text_field = "comments")

reviews_dfm <- dfm(review_corpus)

reviews_dfm[1:5,1:5] #show the first 5 words in the first 5 documents
```
**How to make sense of a DFM?**

DFM is a matrix. Numbers in DFM represent how many times a token (commonly referring to a word or a sentence) appears in a given document. In the output above. The word _awesome_ appears once in document _321027819_. Based on this interpretation, answer the quiz question below.

*reviews_dfm[1:5,1:5]* gives you the frequency distribution of the first 5 words across the first 5 documents. The complete matrix (the object named reviews_dfm) is 13,894 by 9,000. It means that this dfm object has 13,894 features (i.e., words) across 9,000 documents.

**What's next?**

After you have a DFM from your text data, you can do all sorts of things. For instance, run the code below will show you the most frequent terms in your corpus. 

```sh
library(quanteda)

review_corpus <- corpus(reviews,docid_field = "id",text_field = "comments")

reviews_dfm <- dfm(review_corpus)

library(ggplot2)

reviews_dfm %>% 
  textstat_frequency(n = 25) %>% 
  ggplot(aes(x = reorder(feature, frequency), y = frequency)) +
  geom_point() +
  coord_flip() +
  labs(x = NULL, y = "Frequency") +
  theme_minimal()
```


But, wait a minute! The most frequent terms are: _and_, _the_, _a_, period and comma? Shouldn't we take those meaningless and noisy words out of the analysis?

You are right! What I have demonstrated above is a very messy and rudimentary step in text mining. The next topic will cover a set of standard text cleaning and transformation procedures. 
