## Script to get tweet data
import os
from Python.extract.config import * # configuration
import tweepy as twpy
from pymongo import MongoClient

# MongoDB connection
client = MongoClient('mongodb://3.22.27.22:27017')
db = client.final_proj
collection = db.tweets

# Authenticate against Twitter:
auth = twpy.OAuthHandler(twitter_app_key, twitter_app_secret)
auth.set_access_token(twitter_key, twitter_secret)
# Create API object:
api = twpy.API(auth, parser=twpy.parsers.JSONParser())

# Search terms:
mental_health = ["mental health","suicide","depression"]

## STREAMING -----
# Set up stream listener
class StreamListener(twpy.StreamListener):

    def on_status(self, status):
        collection.update(
            {'id': status._json['id']},
            {'$setOnInsert': status._json},
            upsert=True
        )

    def on_error(self, status_code):
        if status_code == 420:
            return False

# Listen
stream_listener = StreamListener()
stream = twpy.Stream(auth=api.auth, listener=stream_listener)
stream.filter(track=mental_health)

client.close()

# api.search(mental_health)
