# Function to load covid data
from datetime import datetime, timedelta

from pymongo import MongoClient
import requests
import pandas as pd

countries = {c['alpha2']: c['name'] for c in requests.get('https://covid19-api.org/api/countries').json()}

def covid_from_mongo(from_date=None, to_date=None):
        client = MongoClient('mongodb://3.22.27.22:27017')
        db = client.final_proj

        if from_date is not None or to_date is not None:
            # In case datetime is passed:
            if type(from_date) is datetime:
                from_date = from_date.isoformat()

            if type(to_date) is datetime:
                to_date = to_date.isoformat()

            cur = db.covid_timeline.find(
                {'last_update':
                     {
                     '$gte': from_date,
                     '$lte': to_date
                     }
                 });
        else:
            cur = db.covid_timeline.find()

        d = []

        for line in cur:
             dict = {}
             dict['country'] = line['country']
             dict['country_name'] = countries[line['country']]
             dict['last_update'] = line['last_update']
             dict['cases'] = line['cases']
             dict['deaths'] = line['deaths']
             dict['recovered'] = line['recovered']
             d.append(dict)

        covid_df = pd.DataFrame(d)

        client.close()

        return covid_df

# test = covid_from_mongo()
# len(set(test.country))
# len(set(test.country_name))
