#This R practice script is used for in-class examples; please complete the interactive tutorial prior to using this script

install.packages("cowsay") #install a library
library(cowsay) #load a library
say("Hello! Welcome to COMM 497DB") #use the say() function in the cowsay library
say("Try me. Hello! I am a cow.", by="cow")
say("I am a pumpkin. Please talk to me.", by="pumpkin")

df <- read.csv("https://curiositybits.cc/files/users.csv") #download a data frame from a server
colnames(df) #show column names
df$description[3] #find the third record on the description column in df

df_new <- df[1:10,c("name","description","location")] #create a new data frame called df_new to include the first 10 rows and the three columns

unique(df$verified) #find unique values in the verified column in df

df_verified <- df[df$verified==TRUE,] #create a new data frame to include only verified users

#how to save a data frame to CSV.
write.csv(df_verified, "saved_df.csv")


