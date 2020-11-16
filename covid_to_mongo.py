from pymongo import MongoClient
from pprint import pprint
import json
import requests

client = MongoClient('mongodb://3.22.27.22:27017')

db = client.final_proj
collection = db.covid

diff = requests.get('https://covid19-api.org/api/diff').json()

for line in diff:
    # collection.insert_one(line)
    collection.update(
        {'country': line['country'], 'last_update': line['last_update']},
        {'$set': line},
        upsert=True
    )

cursor = db.covid.find({})
for line in cursor:
     pprint(line)
# db.covid.delete_many({})