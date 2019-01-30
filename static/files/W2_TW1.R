#load libraries. Make sure the libraries are installed

library(rtweet)

mytoken <- create_token(
  app = "", #app name here
  consumer_key = "", #consumer key here
  consumer_secret = "", #consumer secret here
  access_token = "", #access token here
  access_secret = "") #access secret here

tweets1 <- search_tweets("#breakingnews", n = 50, token=mytoken) #Find 50 tweets (non-retweets) that contain #breakingnews from Twitter Search API

tweets2 <- stream_tweets("", timeout = 10, token=mytoken) #keep streaming tweets for 10 seconds

timeline1 <- get_timelines("SenWarren", n = 200, token = mytoken) #get the recent 200 tweets from Elizabeth Warren, a Senator of Massachusetts (@SenWarren)

timeline2 <- get_timelines(c("realdonaldtrump", "gop", "dnc"), n = 50, token = mytoken) #we will collect the recent 50 tweets from Donald Trump, GOP, and the Democratic Party respectively. 

dt_timeline <- get_timelines("realdonaldtrump", n = 2000, token = mytoken)

dt_rt <- dt_timeline[dt_timeline$is_retweet == TRUE,] #get Trump's retweets

dt_nonrt<- dt_timeline[dt_timeline$is_retweet == FALSE,] #get Trump's original tweets (non-rt)

mentions <- dt_timeline[dt_timeline$is_retweet=="FALSE" & !is.na(dt_timeline$mentions_screen_name),] #get Trump's mentions in his tweets

#learn how to save data frames into csv

save_as_csv(mentions, "trump's_mentions.csv") #this is for saving tweets collected through the library rtweet.

#for saving regular data frames in R, use the following 
write.csv(mentions,"mentions.csv") 
