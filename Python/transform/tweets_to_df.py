# Function to load tweets
from datetime import datetime, timedelta
from dateutil.parser import parse

from pymongo import MongoClient
import pandas as pd
import requests

default_from = (datetime.today() - timedelta(days=5)).isoformat()
default_to = datetime.today().isoformat()
countries = {c['alpha2']: c['name'] for c in requests.get('https://covid19-api.org/api/countries').json()}
us_state_abbrev = {
    'Alabama': 'AL',
    'Alaska': 'AK',
    'American Samoa': 'AS',
    'Arizona': 'AZ',
    'Arkansas': 'AR',
    'California': 'CA',
    'Colorado': 'CO',
    'Connecticut': 'CT',
    'Delaware': 'DE',
    'District of Columbia': 'DC',
    'Florida': 'FL',
    'Georgia': 'GA',
    'Guam': 'GU',
    'Hawaii': 'HI',
    'Idaho': 'ID',
    'Illinois': 'IL',
    'Indiana': 'IN',
    'Iowa': 'IA',
    'Kansas': 'KS',
    'Kentucky': 'KY',
    'Louisiana': 'LA',
    'Maine': 'ME',
    'Maryland': 'MD',
    'Massachusetts': 'MA',
    'Michigan': 'MI',
    'Minnesota': 'MN',
    'Mississippi': 'MS',
    'Missouri': 'MO',
    'Montana': 'MT',
    'Nebraska': 'NE',
    'Nevada': 'NV',
    'New Hampshire': 'NH',
    'New Jersey': 'NJ',
    'New Mexico': 'NM',
    'New York': 'NY',
    'North Carolina': 'NC',
    'North Dakota': 'ND',
    'Northern Mariana Islands':'MP',
    'Ohio': 'OH',
    'Oklahoma': 'OK',
    'Oregon': 'OR',
    'Pennsylvania': 'PA',
    'Puerto Rico': 'PR',
    'Rhode Island': 'RI',
    'South Carolina': 'SC',
    'South Dakota': 'SD',
    'Tennessee': 'TN',
    'Texas': 'TX',
    'Utah': 'UT',
    'Vermont': 'VT',
    'Virgin Islands': 'VI',
    'Virginia': 'VA',
    'Washington': 'WA',
    'West Virginia': 'WV',
    'Wisconsin': 'WI',
    'Wyoming': 'WY'
}

def parsed_location(author_location):
    out = None
    for country_code, country_name in countries.items():
        if country_name in author_location:
            out = country_name
        elif country_code in author_location:
            out = country_name
        elif 'United Kingdom' in author_location or 'London' in author_location or 'England' in author_location or 'Ireland' in author_location or 'Britain' in author_location:
            out = 'United Kingdom of Great Britain and Northern Ireland'
    if out is None:
        for state, state_code in us_state_abbrev.items():
            if state in author_location:
                out = 'United States of America'
            elif state_code in author_location:
                out = 'United States of America'
    if out is None:
        out = author_location
    return out

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
             dict['parse_author_location'] = parsed_location(line['user']['location'])
             dict['author'] = line['user']['screen_name']
             dict['author_id'] = line['user']['id']
             d.append(dict)

        tweets_df = pd.DataFrame(d)

        client.close()

        return tweets_df

def import_latest_tweets(n):
        client = MongoClient('mongodb://3.22.27.22:27017')
        db = client.final_proj

        cur = db.tweets.find().sort('created_at',-1).limit(int(n))

        d = []
        for line in cur:
             dict = {}
             dict['id'] = line['id']
             dict['timestamp'] = parse(line['created_at'])
             dict['text'] = line['text']
             dict['hashtags'] = line['entities']['hashtags']
             dict['coordinates'] = line['coordinates']
             dict['author_location'] = line['user']['location']
             dict['parse_author_location'] = parsed_location(line['user']['location'])
             dict['author'] = line['user']['screen_name']
             dict['author_id'] = line['user']['id']
             d.append(dict)

        tweets_df = pd.DataFrame(d)

        client.close()

        return tweets_df

# test = import_latest_tweets(10)
# test.parse_author_location[1]
