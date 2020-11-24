import pymongo
from pymongo import MongoClient
import pandas as pd
client = MongoClient('mongodb://3.22.27.22:27017')
db = client.final_proj
covid_cur = db.covid_res.find({})
tweets_cur = db.tweets.find({})
covid_df = []
for line in covid_cur:
    print(line)
    covid_df.append(line)
twitter_df = []
for line in tweets_cur:
    print(line)
    twitter_df.append(line)

covid_df = pd.DataFrame(covid_df)
twitter_df = pd.DataFrame(twitter_df)
