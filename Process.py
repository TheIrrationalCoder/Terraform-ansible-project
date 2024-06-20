#""""""""""""""""""""""""""""""""""""""""""""""""
#1. Connect to Mongo DB
#2. Create a simple collection
#3. Read the collection and convert it in HTML 
#    format
#4. Save html file to disk
#""""""""""""""""""""""""""""""""""""""""""""""""

# Define the path of the config file
from configparser import ConfigParser
config_file_path = "/app/files/inventory.ini"

# Get details from Config file
config_obj = ConfigParser(allow_no_value=True)
config_obj.read(config_file_path)

server_name = config_obj.items("dbservers")[0][0].split(" ",1)[0]
#server_port = config_obj.items("dbservers")[0][1].split(" ",1)[1][-5:]

# Connect to the Mongo client
from pymongo import MongoClient
uri = "mongodb://" + config_obj["dbuser"]["username"] + ":" + config_obj["dbuser"]["password"] + "@" + server_name

client = MongoClient(uri)

# Create a test database and insert sample documents into a collection
sample_data_path = "/app/files/SampleData.json"

TAProject_DB = client["TAProjectDB"]
Customer_collection = TAProject_DB["Customers"]
import json
with open(sample_data_path, "r") as data_file:
    data = json.load(data_file)
    inserted_data = Customer_collection.insert_many(data)

data_file.close()

#Random filter on the collection and restrict fields to append to an array
Customers_array = []

for x in Customer_collection.find({"language": "Hindi"}, {"name":1, "language":1, "bio":1, "_id":0}):
    Customers_array.append(x)

#print(Customers_array)

# Read filtered data from collection and convert to html
from json2html import *
html_table = json2html.convert(json=Customers_array)

# Save html file to disk
html_file = open("/app/output/index.html", "w")
html_file.write(html_table)
html_file.close()
