+++
title = "Collect Twitter user timeline"
date = 2019-02-01T23:25:33-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-collect-twitter-user-timeline) on using R for social data analytics.

**What is the rate limit for collecting timeline data**

According to this [Twitter API document](https://developer.twitter.com/en/docs/tweets/timelines/api-reference/get-statuses-user_timeline.html), you can get up to 3,200 of a user's most recent tweets. 

Scrapping tweets from someone's timeline is as easy as running the code below. We will get the recent 200 tweets from Elizabeth Warren, a Senator of Massachusetts (@SenWarren).

```sh
library(rtweet)
library(readr)

mytoken <- create_token(
  app = "", 
  consumer_key = "", 
  consumer_secret = "", 
  access_token = "", 
  access_secret = "") 

timeline1 <- get_timelines("SenWarren", n = 200, token = mytoken)
timeline1 
```
We can collect timeline tweets from multiple accounts by using:

```sh
#we will collect the recent 50 tweets from Donald Trump, GOP, and the Democratic Party respectively. 

timeline2 <- get_timelines(c("realdonaldtrump", "gop", "dnc"), n = 50, token = mytoken)
timeline2
```
Remember the trick we did on R data frames in the [second tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-data-frames)? 
You can split a data frame based on some matching criteria. For example, we can dissect tweets from @realdonaldtrump into retweets (the retweeted content) and non-retweets (the original content).

```sh
dt_timeline <- get_timelines("realdonaldtrump", n = 200, token = mytoken)
dt_rt <- dt_timeline[dt_timeline$is_retweet == TRUE,]
dt_nonrt<- dt_timeline[dt_timeline$is_retweet == FALSE,]
dt_nonrt
```

Here is a challenge for you: can you extract Trump's original tweets (non-retweets) that mention other Twitter users? To give you a hint: the mentioned screen names are stored in the *mentions_screen_name* column. Add the following to your code.

```sh
mentions <- dt_timeline[dt_timeline$is_retweet=="FALSE" & !is.na(dt_timeline$mentions_screen_name),]
```



