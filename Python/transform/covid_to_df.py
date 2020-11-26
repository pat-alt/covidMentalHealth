# Function to load covid data
from datetime import datetime, timedelta

from pymongo import MongoClient
import pandas as pd

def covid_from_mongo(n):
        client = MongoClient('mongodb://3.22.27.22:27017')
        db = client.final_proj

        fromdate = (datetime.today() - timedelta(weeks=6)).isoformat()
        cur = db.covid_timeline.find(
            {'last_update':
                 {'$gte': fromdate
                  }
             }).limit(int(n));


        d = []

        for line in cur:
             dict = {}
             dict['country'] = line['country']
             dict['last_update'] = line['last_update']
             dict['cases'] = line['cases']
             dict['deaths'] = line['deaths']
             dict['recovered'] = line['recovered']
             d.append(dict)

        covid_df = pd.DataFrame(d)

        client.close()

        return covid_df