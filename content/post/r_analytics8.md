+++
title = "Visualizing virality"
date = 2019-02-01T23:57:03-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-visualizing-virality) on using R for social data analytics.

We often wonder which user and what kinds of tweets are more viral. In the divided United States of America, a question that may interest many of you is: _which political party's messages attract more attention and positive responses from the public?_ 

In the following example, we will analyze 3,197 tweets from @GOP and 2,337 tweets by @TheDemocrats since July 2017. We will plot and compare their _daily virality_ (the average number of times a tweet is retweeted by the Twitter public on a given day) and _daily favorability_ (the average number of times a tweet is favorited by the Twitter public on a given day).

Go ahead and run the code below. You will see in the end a daily chart plotting the movement of both parties' virality and favorability.  Can you see which party is more influential on Twitter? 
```sh
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

ggplot(data = daily_count[daily_count$variable=="avg_rt",], aes(x = date_label, y = value, group = screen_name)) +
  geom_line(size = 0.9, alpha = 0.7, aes(color = screen_name)) +
  geom_point(size = 0) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("indicator") + 
  ggtitle("@GOP and @TheDemocrats Twitter Performance")
```

Now, let's reverse engineer the visualization above by unpacking the code block by block.

**Step 1: Know what libraries you would need for the task**

Please take a look at the libraries loaded in the code block below. Notably, we will use the library [_ggplot2_](https://ggplot2.tidyverse.org/), which is for static data visualization. The library [_lubridate_](https://lubridate.tidyverse.org/) is for cleaning up timestamps in tweets. [_dplyr_](https://dplyr.tidyverse.org/) and [_reshape2_](https://cran.r-project.org/web/packages/reshape2/index.html) are two libraries for transforming and summarizing tabular data (i.e., data frames). [_stringr_](https://cran.r-project.org/web/packages/stringr/vignettes/stringr.html) is for cleaning text data.

**Step 2: Download data from a cloud server**

I've collected the tweets using my developer account and the data (in .csv format) are saved at https://curiositybits.cc/files/gop_thedemocrats_timeline.csv. Below you will run the **read.csv()** function to grab the data through the URL provided and put the data in a new data frame called **partytweets**. 

```sh
library(readr)
library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(stringr)

partytweets <- read.csv("https://curiositybits.cc/files/gop_thedemocrats_timeline.csv")

partytweets[1:20,] #view the first 20 observations
```

**Step 3: Tidy up timestamps **

The timestamps of tweets are saved in the **created_at** column. The timestamp format is _YYYY-MM-DD HH-MM-SS_, hence we use the **ymd_hms()** function to standardize the timestamps. **with_tz()** converts all timestamps to the Eastern Time zone. **as.Date()** extract dates from the timestamps and save the date information in a new column called **created_date**. 

```sh
library(readr)
library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(stringr)

partytweets <- read.csv("https://curiositybits.cc/files/gop_thedemocrats_timeline.csv")

partytweets$created_at <- ymd_hms(partytweets$created_at) #standardize timestamps
partytweets$created_at <- with_tz(partytweets$created_at,"America/New_York") #convert to EST
partytweets$created_date <- as.Date(partytweets$created_at) #extract dates

partytweets$created_date
```

**Step 4: Create a daily count of key Twitter indictors **

We will summarize the information in the data frame **partytweets** based on **screen_name** and **date_label**. The aggregated data frame is called **daily_count**.

Note that date_label is idential to the column created_at, but it is stored as a factor. This is because the **group_by()** function does not take the date format. So we need to convert the date object into a factor object. 

```sh
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

partytweets$date_label <- as.factor(partytweets$created_date) #convert the date object into a factor

daily_count <- partytweets %>% 
  group_by(date_label,screen_name) %>% 
  summarise(avg_rt = mean(retweet_count), 
            avg_fav = mean(favorite_count),
            num_retweeted =  length(is_retweet[is_retweet==TRUE]),
            tweet_count = length(unique(status_id))) %>% melt

daily_count
```

**Step 5: Visualize it **

We use **ggplot()** to visualize the data frame **daily_count**. 

We enter the following in the code because we want to visualize daily virality only. That means we filter out observations in **daily_count** with the value equal to "avg_rt" in the **variable** column. 

```sh
data = daily_count[daily_count$variable=="avg_rt",]
```

If you want to plot the number of tweets sent per day, simply set:

```sh
data = daily_count[daily_count$variable=="tweet_count",]
```
The values in **date_label** is plotted along the X axis and whatever is in the **value** column is plotted along the Y axis; we set **group = screen_name** to compare values from two groups: @GOP and @TheDemocrats respectively;

Tweak the numbers in **geom_line()** and **geom_point()** and see what happens;

Change the text in **ylab()** and **ggtitle()** and see what happens. 

```sh
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
partytweets$created_date

partytweets$date_label <- as.factor(partytweets$created_date)

daily_count <- partytweets %>% 
  group_by(date_label,screen_name) %>% 
  summarise(avg_rt = mean(retweet_count),
            avg_fav = mean(favorite_count),
            num_retweeted =  length(is_retweet[is_retweet==TRUE]),
            tweet_count = length(unique(status_id))) %>% melt

daily_count$date_label <- as.Date(daily_count$date_label)

ggplot(data = daily_count[daily_count$variable=="avg_rt",], aes(x = date_label, y = value, group = screen_name)) +
  geom_line(size = 0.9, alpha = 0.7, aes(color = screen_name)) +
  geom_point(size = 0) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("indicator") + 
  ggtitle("@GOP and @TheDemocrats Twitter Performance")

```
