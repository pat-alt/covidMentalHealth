# Function to load tweets
from pymongo import MongoClient
import pandas as pd

def covid_from_mongo(n):
        client = MongoClient('mongodb://3.22.27.22:27017')
        db = client.final_proj
        cur = db.covid_timeline.find({}).limit(int(n))

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

