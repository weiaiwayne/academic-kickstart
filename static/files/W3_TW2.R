library(rtweet)

#authenticate API
mytoken <- create_token(
  app = "", #app name here
  consumer_key = "", #consumer key here
  consumer_secret = "", #consumer secret here
  access_token = "", #access token here
  access_secret = "") #access secret here

#review the common functions used in the previous practice script.

keyword_tweets <- search_tweets("#superbowl", n = 100, token=mytoken) #Find 50 tweets (non-retweets) that contain #breakingnews from Twitter Search API

realtime_tweets <- stream_tweets("", timeout = 4, token=mytoken) #keep streaming tweets for 10 seconds

timeline <- get_timelines("SenWarren", n = 200, token = mytoken) #get the recent 200 tweets from Elizabeth Warren, a Senator of Massachusetts (@SenWarren)

#try some new functions

friends <- get_friends("nntaleb") #get a user's friends

followers <- get_followers("nntaleb", n = 200) #get a user's followers

#collect data from a user's first 20 friends. 
friends <- get_friends("nntaleb")
bio <-  lookup_users(friends$user_id[1:20]) 

#search users by keywords/hashtags
users <- search_users("#umass", n = 100)

##if you are ambitious, try the following to produce a word cloud. 

library(quanteda) #this is a new library, make sure it is installed

dfm <- dfm(users$description, remove = c(stopwords("english"), remove_numbers = TRUE, remove_symbols = TRUE, sremove_punct = TRUE))
set.seed(100)
textplot_wordcloud(dfm, min_size = 1.5, min_count = 10, max_words = 100)

#learn how to save data frames into csv

save_as_csv(users, "users.csv") #this is for saving tweets collected through the library rtweet.

#for saving regular data frames in R, use the following 
write.csv(users,"users.csv") 
