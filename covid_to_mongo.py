from pymongo import MongoClient
import requests

from pprint import pprint
import json

client = MongoClient('mongodb://3.22.27.22:27017')
db = client.final_proj
collection = db.covid
diff = requests.get('https://covid19-api.org/api/diff').json()

for line in diff:
    collection.update(
        {'country': line['country'], 'last_update': line['last_update']},
        {'$setOnInsert': line},
        upsert=True
    )

#optional: commands to print and delete data
# cursor = db.covid.find({})
# for line in cursor:
#      pprint(line)
# db.covid.delete_many({})