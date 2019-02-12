+++
title = "Sentiment analysis"
date = 2019-02-12T00:15:06-05:00
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
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-sentiment-analysis) on using R for social data analytics.

During the 2012 US presidential election, Twitter, in partnership with several polling agencies, launched something called [Twitter Political Index](https://www.socialmediatoday.com/content/twitter-political-index). The idea was to track candidates' popularity among voters based on sentiment expressed in tweets. Back then, such idea was a novelty. Nowadays, sentiment analysis of social media text has been widely applied in [marketing/PR](https://ipullrank.com/step-step-twitter-sentiment-analysis-visualizing-united-airlines-pr-crisis/), [electoral forecasting](https://techcrunch.com/2016/11/10/social-media-did-a-better-job-at-predicting-trumps-win-than-the-polls/), and sports analytics. The NPR show Planet Money even built a [Twitter bot](https://twitter.com/botus?lang=en) to automatically trade stocks based on sentiments in Trump's tweets. 

There are many types of sentiment analysis. Before you work on this tutorial, I assume you have reviewed [this slide](https://curiositybits.cc/files/W4_sentimentdetection.pdf) in which I introduce different approaches to sentiment detection, its strengths and weaknesses. Sentiment analysis is an evolving field in information and computer science. The tutorial only touches upon the very basic of dictionary-based sentiment analysis. If you are keen on learning more, simply google "sentiment analysis" and "R." 

We will work with the same dataset from the last tutorial. The data contain tweets from the two political parties in the US (@GOP and @TheDemocrats). The task is to visualize the sentiment in their tweets over time. Like codes used in previous tutorials, with slight tweaks, you can make the code work for any sort of social media texts (e.g., Facebook posts, YouTube comments, Reddit posts, etc).

Yes. For this task we will use _syuzhet_, a library for extracting sentiments from text. Use **install.packages()** to install and **library()** to load _syuzhet_. 

**How is sentiment detected?**
The library _syuzhet_ uses the dictionary-based approach (as opposed to using supervised machine learning algorithms) in sentiment detection. It uses the [NRC Emotion Lexicon](http://sentiment.nrc.ca/lexicons-for-research/) which rates words by eight dimensions: _joy_, _anger_, _anticipation_, _disgust_, _fear_, _sadness_, _surprise_ and _trust_. 

Run the code below. You should be able to see a plot showing the anger score over time for both parties.

```sh
library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(syuzhet) #this is the library for sentiment detection
library(stringr)

partytweets <- read.csv("https://curiositybits.cc/files/gop_thedemocrats_timeline.csv")

#standardize timestamps
partytweets$created_at <- ymd_hms(partytweets$created_at) 
partytweets$created_at <- with_tz(partytweets$created_at,"America/New_York")
partytweets$created_date <- as.Date(partytweets$created_at)

#create a factor column for dates; used for groupping in later steps
partytweets$date_label <- as.factor(partytweets$created_date)

#clean the text
partytweets$clean_text <- str_replace_all(partytweets$text, "@\\w+", "")

#extract sentiments
Sentiment <- get_nrc_sentiment(partytweets$clean_text)

#combine the data frame containing sentiment scores and the original data frame containing tweets and other Twitter metadata
alltweets_senti <- cbind(partytweets, Sentiment)

#aggregate the data by dates and screennames
senti_aggregated <- alltweets_senti %>% 
  group_by(date_label,screen_name) %>%
  summarise(anger = mean(anger), 
            anticipation = mean(anticipation), 
            disgust = mean(disgust), 
            fear = mean(fear), 
            joy = mean(joy), 
            sadness = mean(sadness), 
            surprise = mean(surprise), 
            trust = mean(trust)) %>% melt

senti_aggregated$day <- as.Date(senti_aggregated$date_label)

#plot the data
ggplot(data = senti_aggregated[senti_aggregated$variable=="anger",], aes(x = day, y = value, group = screen_name)) +
  geom_line(size = 0.5, alpha = 0.6, aes(color = screen_name)) +
  geom_point(size = 0) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("Average sentiment score") + 
  ggtitle("Sentiments Over Time")
  
```
**Step 1: Standardize timestamps and text**

We use the same code from the last tutorial to standardize tweet timestamps based on the **YYYY-MM-DD HH:MM:SS** format. We add **str_replace_all()** to clear out screen names in tweet content and store the clean text in the column **clean_text**. 

```sh
library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(syuzhet) #this is the library for sentiment detection
library(stringr)

partytweets <- read.csv("https://curiositybits.cc/files/gop_thedemocrats_timeline.csv")

#standardize timestamps
partytweets$created_at <- ymd_hms(partytweets$created_at) 
partytweets$created_at <- with_tz(partytweets$created_at,"America/New_York")
partytweets$created_date <- as.Date(partytweets$created_at)

#create a factor column for dates; used for groupping in later steps
partytweets$date_label <- as.factor(partytweets$created_date)

#clean the text
partytweets$clean_text <- str_replace_all(partytweets$text, "@\\w+", "")
partytweets[,c("text","clean_text")] #show two clumns (text and clean_text) in partytweets
```
**Step 2: Create sentiment scores for tweets**

We apply the  **get_nrc_sentiment()** function to the **clean_text** column and get sentiment rating for each tweet. The sentiment scores are stored in the newly created data frame **Sentiment**, with columns corresponding to the types of sentiment and rows matching tweets based on their original order in **partytweets**. We then use the **rbind()** to combine **Sentiment** and **partytweets** so that you can see exactly which tweet receives what sentiment rating (rbind() this is a function used for merging two data frames if they have the same number of columns). 

```sh
library(lubridate)
library(reshape2)
library(dplyr)
library(syuzhet) #this is the library for sentiment detection
library(stringr)

partytweets <- read.csv("https://curiositybits.cc/files/gop_thedemocrats_timeline.csv")

#standardize timestamps
partytweets$created_at <- ymd_hms(partytweets$created_at) 
partytweets$created_at <- with_tz(partytweets$created_at,"America/New_York")
partytweets$created_date <- as.Date(partytweets$created_at)

#create a factor column for dates; used for groupping in later steps
partytweets$date_label <- as.factor(partytweets$created_date)

#clean the text
partytweets$clean_text <- str_replace_all(partytweets$text, "@\\w+", "")
partytweets[,c("text","clean_text")] #show two clumns (text and clean_text) in partytweets

#extract sentiments
Sentiment <- get_nrc_sentiment(partytweets$clean_text)

#combine the data frame containing sentiment scores and the original data frame containing tweets and other Twitter metadata
alltweets_senti <- cbind(partytweets, Sentiment)
alltweets_senti[1:20,] #show the first 20 rows for preview of the data

```
**Step 3: Create daily sentiment scores**

Like how we aggregate data in the last tutorial, we use **group_by()** and **summarise()** to aggregate the data frame **alltweets_senti** based on two columns:**screen_name** and **date_label**. The aggregated data frame is called **senti_aggregated**.

**senti_aggregated** includes daily average counts of each sentiment type for each Twitter account. For example, if @GOP sent 6 tweets on a given day, to calculate the daily anger score, we sum up the anger scores of the 6 tweets and divide the sum by 6.  

```sh
library(lubridate)
library(reshape2)
library(dplyr)
library(syuzhet) #this is the library for sentiment detection
library(stringr)

partytweets <- read.csv("https://curiositybits.cc/files/gop_thedemocrats_timeline.csv")

#standardize timestamps
partytweets$created_at <- ymd_hms(partytweets$created_at) 
partytweets$created_at <- with_tz(partytweets$created_at,"America/New_York")
partytweets$created_date <- as.Date(partytweets$created_at)

#create a factor column for dates; used for groupping in later steps
partytweets$date_label <- as.factor(partytweets$created_date)

#clean the text
partytweets$clean_text <- str_replace_all(partytweets$text, "@\\w+", "")
partytweets[,c("text","clean_text")] #show two clumns (text and clean_text) in partytweets

#extract sentiments
Sentiment <- get_nrc_sentiment(partytweets$clean_text)

#combine the data frame containing sentiment scores and the original data frame containing tweets and other Twitter metadata
alltweets_senti <- cbind(partytweets, Sentiment)

senti_aggregated <- alltweets_senti %>% 
  group_by(date_label,screen_name) %>%
  summarise(anger = mean(anger), 
            anticipation = mean(anticipation), 
            disgust = mean(disgust), 
            fear = mean(fear), 
            joy = mean(joy), 
            sadness = mean(sadness), 
            surprise = mean(surprise), 
            trust = mean(trust)) %>% melt

senti_aggregated

```
**Step 4: Visualize it **

We use **ggplot()** to visualize the data frame **senti_aggregated**. 

We enter the following in the code because we want to visualize daily anger scores only. That means we filter out observations in **senti_aggregated** with the value equal to "anger" in the **variable** column. 


```sh
data = senti_aggregated[senti_aggregated$variable=="anger",]
```

If you want to plot daily average anticipation score, simply set:

```sh
data = senti_aggregated[senti_aggregated$variable=="anticipation",]
```

```sh
library(lubridate)
library(reshape2)
library(dplyr)
library(syuzhet) #this is the library for sentiment detection
library(stringr)

partytweets <- read.csv("https://curiositybits.cc/files/gop_thedemocrats_timeline.csv")

#standardize timestamps
partytweets$created_at <- ymd_hms(partytweets$created_at) 
partytweets$created_at <- with_tz(partytweets$created_at,"America/New_York")
partytweets$created_date <- as.Date(partytweets$created_at)

#create a factor column for dates; used for groupping in later steps
partytweets$date_label <- as.factor(partytweets$created_date)

#clean the text
partytweets$clean_text <- str_replace_all(partytweets$text, "@\\w+", "")
partytweets[,c("text","clean_text")] #show two clumns (text and clean_text) in partytweets

#extract sentiments
Sentiment <- get_nrc_sentiment(partytweets$clean_text)

#combine the data frame containing sentiment scores and the original data frame containing tweets and other Twitter metadata
alltweets_senti <- cbind(partytweets, Sentiment)

senti_aggregated <- alltweets_senti %>% 
  group_by(date_label,screen_name) %>%
  summarise(anger = mean(anger), 
            anticipation = mean(anticipation), 
            disgust = mean(disgust), 
            fear = mean(fear), 
            joy = mean(joy), 
            sadness = mean(sadness), 
            surprise = mean(surprise), 
            trust = mean(trust)) %>% melt

senti_aggregated$day <- as.Date(senti_aggregated$date_label)

#plot the data
ggplot(data = senti_aggregated[senti_aggregated$variable=="anger",], aes(x = day, y = value, group = screen_name)) +
  geom_line(size = 0.5, alpha = 0.6, aes(color = screen_name)) +
  geom_point(size = 0) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("Average sentiment score") + 
  ggtitle("Sentiments Over Time")
```

**Try interactive plotting **
**ggplot2** is a great library for visualization. But if you want to create an interactive plot, you will use a library called [_rCharts_](https://ramnathv.github.io/rCharts/). 

To install rCharts, run the following code.

```sh
require(devtools)
install_github('rCharts', 'ramnathv')
```

After rCharts is installed and loaded, run the following code on the **senti_aggregated** data frame. 


```sh

library(rCharts)
senti_aggreated$day_show <- as.character(senti_aggreated$date_label)

h1 <- hPlot(x = "day_show", y = "value", data = senti_aggreated[senti_aggreated$variable=="anger",], type = "line", group = "screen_name")
h1$print("chart5",include_assets = TRUE)
h1

```


