+++
title = "Text mining: Topic models"
date = 2019-03-04T16:59:23-05:00
draft = false

# Tags and categories
# For example, use `tags = []` for no tags, or the form `tags = ["A ["A Tag", "Another Tag"]` for one or more tags.
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-text-mining-topic-models) on using R for social data analytics.

**What is a topic model?**

Have you dreamed of a day when algorithms can quickly scan through your textbooks and give you a bullet point summary? How convenient! No more tedious reading! Actually, there are algorithms out there that do automatic summarization of large-scale corpus. They are called _topic models_. In building topic models, we basically ask computers to discover some abstract topics from the text. The internal logic is this: words about the same topic tend to be used together in the same or adjacent semantic space. 

**New library?**

The topic model feature is built in the quantaeda library. But you may need to install_topicmodels_.

**The workflow**

Run the code below and wait untill you get an output. 

```sh
library(quanteda)
library(ggplot2)
library(topicmodels)

reviews_tok <- tokens(review_corpus, remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')

reviews_tok <- tokens_select(reviews_tok, min_nchar=3, selection = 'keep')

reviews_dfm <- dfm(reviews_tok)

reviews_dfm <- dfm(review_corpus, remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)

dfm_fortm <- convert(reviews_dfm, to = "topicmodels")
lda <- LDA(dfm_fortm, k = 6)
terms(lda, 10)
```

As you can tell, producing topic models takes time--it is computationally intensive if you hope to build a topic model based on a large-scale corpus. 

In quanteda, we convert a regular DFM object into a format ready for building topic models (see the *convert()* function in the code above). We then apply the *LDA()* function to build a topic mode. LDA stands for Latent Dirichlet allocation. It is one of the most commonly used topic modeling algorithms. *terms(lda, 10)* gives 10 frequent terms from each topic. 

**But, what does *k=6* mean?**

By setting k=6, we ask the LDA algorithm to identify six topics in the corpus. This is where things get extremely complicated and confusing. The algorithm is agnostic about how many topics are there in the corpus. So you will start with a k value and check if the keywords returned shows any clear distinction of topics. If you struggle to summarize the text based on the keywords returned, chances are it is not a good model. Then you will go back and adjust the k value until you find one that gives you somewhat sensible output.

Tuning up a topic model is an art. It is like tuning up a telescope. So based on the corpus we have, let's try different k values. This time, run the code in your own laptop. 

**Extracting meaning?**

Based on your experience with topic models so far, do you think computers can extract true meanings from textual data?
