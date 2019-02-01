+++
title = "Understand R Libraries/Packages"
date = 2019-01-31T22:52:39-05:00
draft = false

# Tags and categories
# For example, use `tags = []` for no tags, or the form `tags = ["A Tag", "Another Tag"]` for one or more tags.
tags = ["social media", "computational","data science","COMM497","R", "automation"]

+++
This post is a static and abbreviated version of this [interactive tutorial](https://curiositybits.shinyapps.io/R_social_data_analytics/#section-librariespackages) on using R for social data analytics.

**What is a library/package?**
Think of R as an operating system (e.g., iOS, Windows) and a library/package as an app running on the system. Each library is designed to accomplish specific tasks. For example, the library _ggplot2_--which is a library we will use throughout the semester--is for visualizing data, and the library _rtweet_ is used for collecting Twitter data.

Use **install.packages()** to install libraries. 
Use **library()**, or **require()** to load an installed library. 

In the example below, we install a fun library called _cowsay_.  

```sh
# install.packages("cowsay") 
#make sure the library name is wrapped by quotation. 

library(cowsay) #load the library, alternatively, you can use require(cowsay)
```

You can run the following in your RStudio and see what happens.

```sh
library(cowsay)
say("Hello! Welcome to COMM 497DB")
```

What's cool about computer programming is that codes are highly customizable: You can add and change parameters within a R function (e.g., **_say()_**). For example, by adding **_by=("cow")_**, you can build a talking cow instead of the default talking cat. 

```sh
library(cowsay)
say("Try me. Hello! I am a cow.", by="cow")
```

