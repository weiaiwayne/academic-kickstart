+++
title = "Collect tweets by keywords/hashtags"
date = 2019-02-01T23:14:56-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-collect-tweets-by-keywordshashtags) on using R for social data analytics.

## Collect tweets by keywords/hashtags

**What Twitter Data are Available?**

From the previous (post)[https://curiositybits.cc/post/r_analytics2/], you have learned that in order to collect data from Twitter API, you must obtain permission, namely. You probably have also noticed that it is not possible to collect as many tweets as you would like to because Twitter imposes _rate limit_ on each API call. As you play around this tutorial, ask yourself this: _Should Twitter make more data available for the public_? Or _has Twitter already revealed too much data to developers?_ 

**Which R library will we be using?**

The most essential library we will use is called _rtweet_ (https://rtweet.info) developed by Michael W. Kearney, a professor of Journalism in the University of Missouri. In previous tutorials, I used a library _twitteR_. _twitteR_ came out earlier in the field and thus is more widely used. But, in terms of ease of use and functionality, _rtweet_ is the best. 

* if you are interested in using _twitteR_, refer to [this old tutorial](http://rpubs.com/cosmopolitanvan/tweetsentiment) 

###  Search API vs. Stream API

Try first with Twitter Search API. Find 50 tweets (non-retweets) that contain #breakingnews. We will put tweets into a data frame called _tweets1_. 

```sh
library(rtweet)
library(readr)

mytoken <- create_token(
  app = "", 
  consumer_key = "", 
  consumer_secret = "", 
  access_token = "", 
  access_secret = "") 

tweets1 <- search_tweets("#breakingnews", n = 50, token=mytoken)
tweets1
```

Twitter rate limits cap the number of search results to 18,000 every 15 minutes. You can simply add set **_retryonratelimit = TRUE**_ and _rtweet_ will wait for rate limit resets for you. ([more info](https://rtweet.info/articles/intro.html)). 
See the example belove. 

```sh
tweets1 <- search_tweets("#breakingnews", n = 18000, token=mytoken, retryonratelimit = TRUE)
```

** Next, we will collect tweets from Twitter Stream API. Notice how Stream API differs from Search API. The returned tweets will be put in the data frame named _tweets2_.

```sh
library(rtweet)
library(readr)

mytoken <- create_token(
  app = "", 
  consumer_key = "", 
  consumer_secret = "", 
  access_token = "", 
  access_secret = "") 

tweets2 <- stream_tweets("", timeout = 10, token=mytoken)
tweets2
```
** By setting **timeout = 10**, we ask _rtweet_ to keep streaming tweets for 10 seconds. You can set a higher value on your machine. By keeping the search field empty, we ask _rtweet_ to randomly sample (approximately 1%) from the live stream of all tweets. 

