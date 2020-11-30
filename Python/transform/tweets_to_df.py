# Function to load tweets
from datetime import datetime, timedelta
from dateutil.parser import parse

from pymongo import MongoClient
import pandas as pd

default_from = (datetime.today() - timedelta(days=5)).isoformat()
default_to = datetime.today().isoformat()

def tweets_from_mongo(from_date=default_from, to_date=default_to):
        client = MongoClient('mongodb://3.22.27.22:27017')
        db = client.final_proj

        cur = db.tweets.find(
            {'created_at':
                 {
                 '$gte': from_date
                 # '$lte': to
                 }
             });

        d = []
        for line in cur:
             dict = {}
             dict['id'] = line['id']
             dict['timestamp'] = parse(line['created_at'])
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

def import_latest_tweets(n):
        client = MongoClient('mongodb://3.22.27.22:27017')
        db = client.final_proj

        cur = db.tweets.find().limit(int(n))

        d = []
        for line in cur:
             dict = {}
             dict['id'] = line['id']
             dict['timestamp'] = parse(line['created_at'])
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


twt = import_latest_tweets(10)
idx = twt.columns.get_loc('id')
twt.iloc[:,idx+5]
