## Script to get tweet data

from config import * # configuration
import tweepy as twpy

# Authenticate against Twitter:
auth = twpy.OAuthHandler(twitter_app_key, twitter_app_secret)
auth.set_access_token(twitter_key, twitter_secret)
# Create API object:
api = twpy.API(auth)

# Set up stream listener
