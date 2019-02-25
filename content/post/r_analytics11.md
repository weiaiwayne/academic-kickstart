+++
title = "Clean messy text"
date = 2019-02-25T16:52:50-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-text-mining-clean-messy-text) on using R for social data analytics.


**Why text cleaning?**

Textual data are always messy. The data may contain words that, if taken out of context, would be meaningless. You may also encounter a group of different words which convey the same meaning. Or you might have to convert slangs and acronyms into standard English, or emojis into something computer can recognize. Only by cleaning the mess and the noise in the text will you be able to discern useful patterns and signals. 


**Tokenization**
The text cleaning process mainly occurs during tokenization. Tokenization is part of the text mining workflow. But we did not cover that in the last tutorial because the dfm() function performs tokenization under the hood. In other words, by default, dfm() tokenizes your text first before constructing a DFM object. But, sometimes, we need to call the tokens() function to apply additional cleaning criteria on top of the default setting in dfm().

Remember we have a pre-created corpus, called review_corpus, which contains 9,000 documents of Airbnb reviews? Run the code below and see what happens.

```sh
library(quanteda)

reviews <- read.csv("https://curiositybits.cc/files/airbnb_reviews_2018_sample.csv")
review_corpus <- corpus(reviews,docid_field = "id",text_field = "comments")
tokens(review_corpus[5])
```

**tokens(), by default, segments a corpus into tokens where each token represents a word**. The code above tokenizes the 5th document (i.e., the 5th document) in the corpus. 

We commonly tokenize corpus based on words. The following code tokenizes the corpus based on sentences so that each unique sentence is treated as a token. We do that by adding *what = "sentence* to the *tokens()* function. 

```sh
tokens(review_corpus[5],what = "sentence")
```

In the code below, a number of cleaning criteria are added. Observe changes in the output. 

```sh
tokens(review_corpus[5],remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)
```

This time, tokens() segments our corpus into word tokens, but in the process, remove punctuation marks, numbers, symbols, Twitter handles and hashtags, and URLs. As discussed early, choosing what cleaning criteria to apply should be decided on a case by case basis. For some tasks, you may want to preserve Twitter handles and hashtags because they hold the key to understanding your data. You may also want to preserve punctuations if you are interested in how punctuations convey emotions. 

Now, let's apply tokens() to tokenize the whole corpus and identify the most frequent terms. The tokenization produces an object call *review_tok*. We can create a DFM from review_tok.

```sh
library(quanteda)
library(ggplot2)

review_tok <- tokens(review_corpus,remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_dfm <- dfm(review_tok)

#find 20 most frequent terms
topfeatures(reviews_dfm, 20)
```

Hold on, the most frequent terms are: _and_, _the_, _a_, _to_, _was_, _is_? This tells us hardly anything interesting about the data. Well, this is because there are common stop words in our data. [Stop words](https://en.wikipedia.org/wiki/Stop_words) are commonly used function words that we ask algorithms to ignore in processing text data. In many text mining tasks, we reckon such stop words as meaningless noises. But, there is a school of thoughts that argue how people use function words (e.g., _the_, _is_, _at_, _which_, and _on_) reveals important insights about social identities, power dynamics in a communication context, and personality. [Read more here](https://www.npr.org/sections/health-shots/2012/04/30/151550273/to-predict-dating-success-the-secrets-in-the-pronouns).

To remove stop words from review_tok (the tokenized corpus created from the previous step), use the code below. 

```sh
reviews_tok <- tokens(review_corpus[5],remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')
```

Alternatively, you can directly use *remove = stopwords("english")* inside the *dfm()* function. It will do the same trick. 

```sh
library(quanteda)
library(ggplot2)

reviews_dfm <- dfm(review_corpus, remove = stopwords("english"), stem = FALSE, remove_punct = TRUE)
```

Ever wonder what *stem = FALSE* means in the code above? Or do you want to try other cleaning criteria? Run the below code blocks. Each will test a new set of cleaning criteria.

```sh
library(quanteda)
reviews_tok <- tokens(review_corpus[5],remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, min_nchar=3, selection = 'keep')
reviews_tok
```

And try this. 
```sh
library(quanteda)

reviews_tok <- tokens(review_corpus[5],remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, pattern = c("lockbox","guests","however"), selection = 'remove')

reviews_tok

```
The code above can be handy when we want to create our own list of filter words. Note that the tokenization process will automatically convert anything into lower cases, so instead of adding "However" as a filter word, we added "however."

**Stemming**

Here comes the mysterious *stem = FALSE* in the code. Run the code below and see the output. Notice that *stem* is set to *TRUE*.

```sh
library(quanteda)
library(ggplot2)

reviews_dfm <- dfm(review_corpus, remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)

reviews_dfm[1:5,1:10]
```

_Stemming_ refers to a cleaning process that chops off the ends of words. Why do we do that? This is because different words (e.g., _working_, _works_, and _worked_) may share a same stem/root word and thus convey similar meaning. In text mining, we might want to treat such words as identical.


