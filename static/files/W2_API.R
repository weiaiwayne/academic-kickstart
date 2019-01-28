## PART 1: Web crawling

#You can try the web crawler below to extract a list of members of the House of Representatives from Wikipedia
# example from https://twitter.com/juliasilge/status/951639629182074880

library(rvest)
library(tidyverse)
h <- read_html("https://en.wikipedia.org/wiki/Current_members_of_the_United_States_House_of_Representatives")

reps <- h %>%
  html_node("table#votingmembers") %>%
  html_table(fill = TRUE)

## PART 2: Use Twitter API (REQUIRED)

library(rtweet)
library(readr)

#replace the following API credentials with the one posted on Moodle. 
mytoken <- create_token(
  app = "APP1", #app name here
  consumer_key = "DSD62iGWw16nMwaCSLkzfSQA", #consumer key here
  consumer_secret = "p62iGWw16nMwaCSLkzfSQA", #consumer secret here
  access_token = "153474365-XuWYfmlE423Ew6yuUM6Jfm7GMRHWJXzclWNPGCFmM", #access token here
  access_secret = "tHqOHqOxAqhaXHWlkXQ76HBQ7NVIXOrwvGRiH5cnsNE") #access secret here

#now test if we can connect to the API by searching 100 recent tweets that contain a keyword of your interest.  
tweets <- search_tweets("#privacy", n = 100, token=mytoken)
tweets


## PART 3: Try YouTube's API.
install.packages("devtools")
devtools::install_github("soodoku/tuber", build_vignettes = TRUE)

library(tuber)

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
