library(readr)
library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(stringr)

partytweets <- read.csv("https://curiositybits.cc/files/gop_thedemocrats_timeline.csv")
partytweets$created_at <- ymd_hms(partytweets$created_at) 
partytweets$created_at <- with_tz(partytweets$created_at,"America/New_York")
partytweets$created_date <- as.Date(partytweets$created_at)

partytweets$date_label <- as.factor(partytweets$created_date)

daily_count <- partytweets %>% 
  group_by(date_label,screen_name) %>% 
  summarise(avg_rt = mean(retweet_count),
            avg_fav = mean(favorite_count),
            num_retweeted =  length(is_retweet[is_retweet==TRUE]),
            tweet_count = length(unique(status_id))) %>% melt


daily_count$date_label <- as.Date(daily_count$date_label)

ggplot(data = daily_count[daily_count$variable=="avg_rt",], 
       aes(x = date_label, y = value, group = screen_name)) +
  geom_line(size = 0.9, alpha = 0.7, aes(color = screen_name)) +
  geom_point(size = 0) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("indicator") + 
  ggtitle("@GOP and @TheDemocrats Twitter Performance")