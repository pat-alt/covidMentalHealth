from pymongo import MongoClient
import requests

client = MongoClient('mongodb://3.22.27.22:27017')
db = client.final_proj
col_diff = db.covid_diff
col_res = db.covid_res
diff = requests.get('https://covid19-api.org/api/diff').json()
res = requests.get('https://covid19-api.org/api/status').json()

for line in diff:
    col_diff.update(
        {'country': line['country'], 'last_update': line['last_update']},
        {'$setOnInsert': line},
        upsert=True
    )

for line in res:
    col_res.update(
        {'country': line['country'], 'last_update': line['last_update']},
        {'$setOnInsert': line},
        upsert=True
    )

#optional: commands to print and delete data

# from pprint import pprint
# import json

# cursor = db.covid.find({})
# for line in cursor:
#      pprint(line)
# db.covid.delete_many({})

client.close()
