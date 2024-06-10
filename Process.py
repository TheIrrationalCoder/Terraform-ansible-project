#""""""""""""""""""""""""""""""""""""""""""""""""
#1. Connect to Mongo DB
#2. Create a simple collection
#3. Read the collection and convert it in HTML 
#    format
#4. Save html file to disk
#""""""""""""""""""""""""""""""""""""""""""""""""

# Define the path of the config file
from yaml import safe_load
config_file_path = "/app/files/Config.yaml"

# Get details from Config file
with open(config_file_path, "r") as file:
    config = safe_load(file)
    server_info = config[0]["DB_server"]
    server_name = server_info["name"]
    server_port = server_info["port"]
    server_user_name = server_info["username"]
file.close()
#print(server_name,server_port,server_user_name)

# Connect to the Mongo client
from pymongo import MongoClient
client = MongoClient(server_name,server_port)

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


