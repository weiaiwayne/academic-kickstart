+++
title = "Collect Twitter user info"
date = 2019-02-01T23:35:23-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-collect-twitter-user-info) on using R for social data analytics.

**Collecting user information? That sounds creepy!**

Not at all. We will conduct the data collection in strict compliance with Twitter’s developer terms. In fact, just like the rate limits imposed on collecting tweets, Twitter makes it very limited as to what kind of user profile data are available through its API. 

**What can you do with the Twitter user data?**

After running the code in this part of the tutorial, you will end up with a data frame containing a bunch of screen names and associated profile bios. You might ask: what can I do with it? You will be surprised by how much insights we can draw by just studying the user profiles. For example, we can use artificial intelligence to predict a user's ideology. We will, of course, save the topic for another tutorial. 

###  Get followers and friends

Running the code below, we can get Nassim Nicholas Taleb's (@nntaleb) followers and friends. Nassim Nicholas Taleb is one of my favorite authors. He wrote the famous [_The Black Swan: The Impact of the Highly Improbable: With a new section: "On Robustness and Fragility"_](https://www.amazon.com/Black-Swan-Improbable-Robustness-Fragility/dp/081297381X). Interestingly, Taleb served as a [UMass-Amherst faculty from January 2005 to January 2006](https://www.muckrock.com/foi/massachusetts-1/nassim-nicholas-taleb-emails-20264/).

```sh
library(rtweet)
library(readr)

mytoken <- create_token(
  app = "", 
  consumer_key = "", 
  consumer_secret = "", 
  access_token = "", 
  access_secret = "") 

friends <- get_friends("nntaleb")
followers <- get_followers("nntaleb", n = 200)
friends
```
Note that by setting _n = 200_, we will be getting only 200 followers from @nntaleb. Taleb has a huge following (>343k). Getting all of his followers will definitely crash this server. On your local machine, you can set a higher n, say, _n=75000_. According to the [_rtweet_ document](https://rtweet.info/articles/intro.html), you can add _retryonratelimit = TRUE_ (see the code below) to grab a complete follower list. However, due to the rate limit, the code has to run continuously for days!

```sh
## see how many total followers does @nntaleb have?
nntaleb <- lookup_users("nntaleb")
## get them all (this would take a little over 5 days)
followers <- get_followers("nntaleb", n = nntaleb$followers_count, retryonratelimit = TRUE)
```
Yes, _friends_ contains only a list of user ids. We need more info than that! Try the code below to grab Twitter profile bios based on ids. In order not to over-burden the server, we will collect from the first 20 friends only.

```sh
friends <- get_friends("nntaleb")
#collect data from the first 20 friends. 
bio <-  lookup_users(friends$user_id[1:20]) 
```
Before wrapping up, let's try another cool feature in _rtweet_. _rtweet_ allows you to search users by keyword/hashtag through Twitter API. Use the code below to find 100 users with the #umass hashtag in their profile bios.

```sh
users <- search_users("#umass", n = 100)
```
