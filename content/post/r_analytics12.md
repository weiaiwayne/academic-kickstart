+++
title = "Text mining: discover insights"
date = 2019-03-04T16:14:25-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-text-mining-discover-insights) on using R for social data analytics.

Now you are on course to try basic text mining techniques to extract insights from textual data. In this tutorial, we will try four techniques: *simple word frequency, word cloud, n-grams, and keyness.* 

**Simple word frequency**

Suppose we want to see how often the word "noisy" appears in Airbnb reviews from the three cities respectively. We first create a tokenized corpus called *reviews_tok* and then use the dfm() function to create a DFM. Subsequently, we ask R to group the text based on the _city_ column. With the grouped DFM, we can inspect the word frequency across documents. 

```sh
library(quanteda)

reviews_tok <- tokens(review_corpus,remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')

reviews_dfm <- dfm(reviews_tok, group="city") #use the city column as the grouping variable
 
reviews_dfm[,"noisy"] 
```

It appears that _noise_ is a common complaint among Airbnb users who stayed in Boston. 

Next, we use ggplot2 to visualize the most frequent terms by group (city). We use *textstat_frequency()* function to calculate the frequency. Inside the function, we set *n=20* to get the 20 most frequent terms, and *groups = "city"* to ask for a breakdown of the frequency by three cities. 

```sh
library(quanteda)
library(ggplot2)

reviews_tok <- tokens(review_corpus,remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')

reviews_dfm <- dfm(reviews_tok) 

#get frequency count for keywords by groups
freq <- textstat_frequency(reviews_dfm, n = 20, groups = "city")

ggplot(data = freq, aes(x = nrow(freq):1, y = frequency)) +
     geom_point() +
     facet_wrap(~ group, scales = "free") +
     coord_flip() +
     scale_x_continuous(breaks = nrow(freq):1,
                        labels = freq$feature) +
     labs(x = NULL, y = "Relative frequency")
```

**Word cloud**

In addition to plotting the most frequent terms, we can create a word cloud for city-by-city comparison.   

```sh
library(quanteda)
library(ggplot2)

reviews_tok <- tokens(review_corpus,remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')

reviews_dfm <- dfm(reviews_tok, groups="city") 

set.seed(132)
textplot_wordcloud(reviews_dfm, comparison = TRUE, max_words = 200)
```

**Keyness**

Based on the frequency plot and word cloud, can you discern any noticeable difference in the reviews across three cities? Well, it appears that the most frequent terms are quite similar across. But, just because a  term is frequent, does not mean it is a "keyword." In text mining, keywords are measured by ["keyness"](http://www.thegrammarlab.com/?p=193). It smeans how _distinctive_ a word is for a corpus when compared to a different corpus. For instance, there are terms frequently used in describing the Airbnb experience in Boston, but not so often used in reviews about the Airbnb experience in other cities. We can use the *textstat_keyness* function to find these terms based on the keyness measure. 

```sh
library(quanteda)
library(ggplot2)

reviews_tok <- tokens(review_corpus,remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')

reviews_dfm <- dfm(reviews_tok, groups="city") 

result_keyness <- textstat_keyness(reviews_dfm, target = "Boston") 

# Plot estimated word keyness
textplot_keyness(result_keyness) 
```
**N-gram**

Text mining is a process of data reduction. It simplifies a complex text into tokens. Along the way, lots of information is lost, especially, when you take single words out of context. Next, we will try [N-grams](https://en.wikipedia.org/wiki/N-gram). N-grams can preserve multi-word phrases and expressions. 

```sh
library(quanteda)
library(ggplot2)

reviews_tok <- tokens(review_corpus,remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')

#create a bi-gram
toks_ngram <- tokens_ngrams(reviews_tok, n = 2)

reviews_dfm <- dfm(toks_ngram, groups="city") 

set.seed(132)
textplot_wordcloud(reviews_dfm, comparison = TRUE, max_words = 200)
```

*toks_ngram <- tokens_ngrams(reviews_tok, n = 2)* is the code you use to create bigrams from the tokenized corpus called reviews_tok. Now observe how the output has changed.
