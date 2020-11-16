## Script to get tweet data
from config import * # configuration
import tweepy as twpy

# Authenticate against Twitter:
auth = twpy.OAuthHandler(twitter_app_key, twitter_app_secret)
auth.set_access_token(twitter_key, twitter_secret)
# Create API object:
api = twpy.API(auth, parser=twpy.parsers.JSONParser())

# Search terms:
mental_health = ["mentalhealth","mental","health","suicide","depression"]

## SEARCHING ----
results = api.search(q=mental_health, count=10)

## STREAMING -----
# Set up stream listener
class StreamListener(twpy.StreamListener):
    def on_status(self, status):
        if status.retweeted_status:
            return
        return status
    def on_error(self, status_code):
        if status_code == 420:
            return False

# Listen
stream_listener = StreamListener()
stream = twpy.Stream(auth=api.auth, listener=stream_listener)
# stream.filter(track=mental_health)
