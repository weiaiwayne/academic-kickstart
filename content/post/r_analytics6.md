+++
title = "Collect YouTube Data"
date = 2019-02-01T23:40:52-05:00
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
Tufekci (2014) wrote that "Twitter has become to social media scholars what the fruit fly is to biologists—a model organism." But, let's not forget that there are so many web platforms out there. Arguably, Facebook provides far richer insights than Twitter given its comparatively larger user base and higher penetration rate around the world. Unfortunately, Facebook has shutted down much of its API, making our [previous tutorials on Facebook-based data mining](https://static1.squarespace.com/static/559085e9e4b0942571880993/t/57e1feb4f7e0abedb4cd7071/1474428599129/R+Workshop-Download-Facebook-Twitter-Data.pdf) obsolete. 

I hope we take comfort in the fact that Google's API remains largely open. Using Google's API, we can collect metadata from YouTube (e.g., YouTube videos' statistics and comments). 

**What are the required libraries for this task**
We need a library called [tuber](http://soodoku.github.io/tuber/). It is not something you can install by just running _install.packages()_. You would first need to install a library called _devtools_ and then execute the following code to install _tuber_ from its development version from [GitHub](github.com).

```sh
install.packages("devtools")
devtools::install_github("soodoku/tuber", build_vignettes = TRUE)
```
**What should I know about YouTube's API**
Unlike Twitter, which requires you to access its API through a vetted developer account. Google's API (note: YouTube is owned by Google) is open to all Google users. You can review the steps in [the later part of the slide](https://curiositybits.cc/files/W2_1.pdf).

You can set up Google API access using your own Google account. 

```sh
#connect to YouTube's API. More at https://github.com/soodoku/tuber
yt_oauth("enter Client ID here", "enter Client secret here",token = '')

#get video stats
videostats <- get_stats(video_id = "0JMkzakXgIY")

#Get Information About a Video
videodetails <- get_video_details(video_id = "0JMkzakXgIY")

#Search videos
video_search <- yt_search("Nick Sandmann")

#Get All the Comments Including Replies
comments <- get_all_comments(video_id = "0JMkzakXgIY")

#Get Captions of a Video (still under testing)
captions <- list_caption_tracks(part = "snippet", video_id = "q7Eb4KVw4nE")
get_captions(id = "lvnNItHaLK1QZwMrO67nEelmK37ml7Fh")
```

**Reference**

Tufekci Z. 2014. Big questions for social media big data: representativeness, validity and other methodological pitfalls. arXiv:1403.7400 [cs.SI]


