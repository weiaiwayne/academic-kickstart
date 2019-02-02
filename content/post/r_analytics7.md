+++
title = "Make Wordclouds"
date = 2019-02-01T23:44:12-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-make-wordclouds) on using R for social data analytics.

Wordclouds are perhaps the most basic way of representing text data. You can simply use wordclouds to reveal important topics in a large body of tweets or to get a sense of user demographics based on keywords used in Twitter bio pages.

**Do I need new libraries?**

Yes, we will use _quanteda_ for creating wordclouds. _quanteda_ (https://quanteda.io/) is a library built for advanced text mining, It is fairly new and includes a great deal of cutting-edge text mining techniques such as topic modeling and semantic network analysis. We will cover the more advanced use later in the semester. For now, we stick with the simple act of generating wordclouds.

Below we will use pre-collected Twitter user data, which are saved as a CSV file on my server. We use _read.csv()_ to download the data into the data frame _users_. The data contain 966 users with #maga (Make America Great Again) hashtag on Twitter bios. 

We convert the information in the _description_ column (which stores the user bios) to characters (note: this is optional if your raw data are already standardized as characters). We then convert the text into something called _dfm_. 

**What is dfm?**

It stands for [document-feature matrix](https://tutorials.quanteda.io/basic-operations/dfm/). It is, simply put, a structured and quantified text format that many analyses in _quanteda_ are based on. 

In creating the dfm, we remove [stopwords](https://en.wikipedia.org/wiki/Stop_words), numbers,  symbols, and punctuations. Lastly, we turn _dfm_ into a wordcloud. You can tweak parameters in the textplot_wordcloud() function to change the colors and layouts of the wordcloud. For example, if you want to show fewer words, set _max_words_ for a lower number.

```sh
library(quanteda)
library(readr)

users <- read.csv("https://curiositybits.cc/files/users.csv")

users$description <- as.character(users$description) 

dfm <- dfm(users$description, remove = c(stopwords("english"), remove_numbers = TRUE, remove_symbols = TRUE, sremove_punct = TRUE))

#uncomment the next line to get a wordcloud based on hashtags.
#dfm <- dfm_select(dfm, pattern = ("#*"))

set.seed(100)
textplot_wordcloud(dfm, min_size = 1.5, min_count = 10, max_words = 100)

```

**Have you spotted anything interesting in the wordcloud?**

There are probably many words in the wordcloud that, if taken out of context, would be subject to many interpretations. To reduce the noise in the data, we can try showing only hashtags as many users express identities through hashtags. 

To do this is simple. Just find the following line in the code block and uncomment it. Then re-run the code. This line of code extracts strings that begin with # from _dfm_.

```sh
dfm <- dfm_select(dfm, pattern = ("#*"))
```

