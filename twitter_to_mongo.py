from pymongo import MongoClient
from pprint import pprint
import json

client = MongoClient('mongodb://3.22.27.22:27017')

db = client.final_proj
collection = db.tweets
with open('tweet_sample.json') as f:
    for line in f:
        file_data = json.loads(line)
        collection.insert_one(file_data)

# cursor = db.tweets.find({})
# for tweets in cursor:
#      pprint(tweets)
# db.tweets.delete_many({})

