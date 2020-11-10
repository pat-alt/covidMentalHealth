from pymongo import MongoClient
from pprint import pprint

client = MongoClient('mongodb://3.22.27.22:27017')

#switch to test db
db = client.test

#insert data to inventory schema
db.inventory.insert_one(
    {"item": "canvas",
     "qty": 100,
     "tags": ["cotton"],
     "size": {"h": 28, "w": 35.5, "uom": "cm"}})

# load inventory schema into cursor
cursor = db.inventory.find({})

#print all objects in inventory
for inventory in cursor:
     pprint(inventory)

#delete all canvas objects in inventory
db.inventory.delete_many({"item": "canvas"})

