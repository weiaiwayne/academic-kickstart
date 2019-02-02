+++
title = "Connecting to the Twitter API"
date = 2019-02-01T23:04:17-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-connecting-to-the-twitter-api) on using R for social data analytics.

**What is Twitter API?**
API (Application Programming Interface) is a marketplace of data. Twitter makes some of its data publically available and free of access. To obtain the data, you must register a client app and complete the authentification process. Here you will learn how to connect to the Twitter API with pre-obtained credentials: _consumer key_, _consumer secret_, _access token_, and _access secret_. 
To authenticate Twitter API in the library _rtweet_, run the following code:

```sh
library(rtweet)
library(readr)

mytoken <- create_token(
  app = "", #enter the app name
  consumer_key = "", #enter consumer key
  consumer_secret = "", #enter consumer secret
  access_token = "", #enter access token
  access_secret = "") #enter access secret
```
Test if we can connect to the API by searching 100 recent tweets that contain a keyword of your interest.  

```sh
tweets <- search_tweets("#privacy", n = 100, token=mytoken)
tweets
```

**The Twitter API as you know it may not be here forever**

It is difficult to keep up with where things are at the Twitter API as its API has undergone a number of big changes over the past years. The current version of the Twitter API is more restrictive than ever. You might have heard a thing called _rate limit_, meaning there is a limit on how many times you can make a request for data within a 15-minute window (see https://developer.twitter.com/en/docs/basics/rate-limiting.html). Moreover, historical tweets (tweets sent over a week ago) are NOT available. You must purchase historical tweets through a paid Twitter API subscription (see pricing at https://developer.twitter.com/en/account/subscriptions) or third-party data vendors (e.g., GNIP).

The increasingly restrictive API is partly a result of public and regulatory pressures after the Cambridge Analytica scandal and all the talks about foreign interference in elections through social media. A more privacy-minded Twitter is good news for consumers. But whether or not its latest API policies can actually protect users is up to debate. Twitter's recent API change has made some data analytics companies' business model obsolete (including one company launched by a former UMass professor in Amherst, MA). Also, there is a growing consensus within the researcher community that Twitter should have a more lax API policy for academic researchers.

If you are interested in the debate, here are some good reads:

https://www.bloomberg.com/opinion/articles/2018-10-16/twitter-s-barriers-for-academic-researchers-are-misguided 

https://socialmediaandpolitics.org/53-digital-methods-post-api-era-deen-freelon/ 


