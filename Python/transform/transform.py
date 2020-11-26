# Function to load tweets
from pymongo import MongoClient
import pandas as pd

def load_from_mongo(n):
        client = MongoClient('mongodb://3.22.27.22:27017')
        db = client.final_proj
        covid_cur = db.covid_res.find({})
        tweets_cur = db.tweets.find({}).limit(int(n))

        d = []
        #body, hashtags, time/date, retweet count, user, geocoordinates
        for line in tweets_cur:
             dict = {}
             dict['id'] = line['id']
             dict['timestamp'] = line['created_at']
             dict['text'] = line['text']
             dict['hashtags'] = line['entities']['hashtags']
             dict['coordinates'] = line['coordinates']
             dict['author_location'] = line['user']['location']
             dict['author'] = line['user']['screen_name']
             dict['author_id'] = line['user']['id']
             d.append(dict)

        tweets_df = pd.DataFrame(d)

        client.close()

        return tweets_df

load_from_mongo(100)
