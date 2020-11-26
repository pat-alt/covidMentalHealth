# Function to load tweets
from datetime import datetime, timedelta
from dateutil.parser import parse

from pymongo import MongoClient
import pandas as pd

def tweets_from_mongo(n):
        client = MongoClient('mongodb://3.22.27.22:27017')
        db = client.final_proj

        fromdate = (datetime.today() - timedelta(weeks=6)).isoformat()
        cur = db.tweets.find(
            {'created_at':
                 {'$gte': fromdate
                  }
             }).limit(int(n));

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

