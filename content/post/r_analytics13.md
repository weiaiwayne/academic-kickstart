+++
title = "Text mining: Semantic network"
date = 2019-03-04T16:55:57-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-text-mining-semantic-network) on using R for social data analytics.

To understand what a semantic network looks like, go ahead and run the code below.

```sh
library(quanteda)
library(ggplot2)

reviews_tok <- tokens(review_corpus, remove_punct = TRUE,remove_numbers = TRUE, remove_symbols = TRUE, remove_twitter=TRUE, remove_url=TRUE)

reviews_tok <- tokens_select(reviews_tok, pattern = stopwords('en'), selection = 'remove')

reviews_tok <- tokens_select(reviews_tok, min_nchar=3, selection = 'keep')

reviews_dfm <- dfm(reviews_tok)

#create a feature co-occurrence matrix (FCM)
review_fcm <- fcm(reviews_dfm) 

#extract the top 50 frequent terms from the FCM object
feat <- names(topfeatures(review_fcm, 50)) 

#trim the old FCM object into a one that contains only the 50 frequent terms 
fcm_select <- fcm_select(review_fcm, pattern = feat)

set.seed(144)
textplot_network(fcm_select, min_freq = 0.8)
```

What you see in the output are a bunch of words interconnected to each other. A semantic network can tell us the most central concept/ideas in your corpus. We can use mathematical functions to quantify each position in a semantic network. For example, centrally located words tend to have higher [_betweenness centrality_](https://en.wikipedia.org/wiki/Betweenness_centrality). Even without any mathematic calculation, we can easily spot the most central words based on the visualization.  In the corpus of Airbnb reviews, the most central word is _place_. The concept of semantic networks is developed from the [graph theory](https://en.wikipedia.org/wiki/Graph_theory) and [social network analysis](https://en.wikipedia.org/wiki/Social_network_analysis). We will have a separate set of tutorials on online social networks.

**How are words connected to one and another?** You may wonder about that. In quantaeda, a semantic network is referred to as feature co-occurrence matrix (FCM). It is a type of network based on co-occurrence: more specifically, two words are linked to each other if they appear in the same document. In our case, two words are connected to each other if they occur in the same review. 

The semantic network approach can be useful in mapping out central ideas and see how different ideas are connected and clustered. A shortcoming here, though, is that there are too many vague words (e.g., _next_, _first_, _lots_)in the corpus. A refined approach is tagging each word token as noun, adjective, or verb (a process called [Part-of-speech tagging](https://www.bing.com/search?q=pos+tagging&PC=U316&FORM=CHROMN)) and then create a semantic network based only on one type of words, say, a semantic network entirely based on nouns or adjectives. You may also consider this approach in analyzing Twitter hashtags. You will learn alot by looking at how different hashtags are concentrated and clustered based on their co-occurrence in the same tweet. If you want to know how to create a semantic network based on hashtags, revist the code [here](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-make-wordclouds). 

