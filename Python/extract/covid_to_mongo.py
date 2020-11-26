from pymongo import MongoClient
import requests

client = MongoClient('mongodb://3.22.27.22:27017')
db = client.final_proj
collection = db.covid_timeline

base_url = 'https://covid19-api.org/api/timeline/'
countries = [c['alpha2'] for c in requests.get('https://covid19-api.org/api/countries').json()]
data = [requests.get(f'{base_url}{c}').json() for c in countries]

for country in data:
    for line in country:
        collection.update(
            {'country': line['country'], 'last_update': line['last_update']},
            {'$setOnInsert': line},
            upsert=True)
    print(f'inserted data for {country}')


#optional: commands to print and delete data

# from pprint import pprint
# import json

# cursor = db.covid.find({})
# for line in cursor:
#      pprint(line)
# db.covid.delete_many({})

client.close()
