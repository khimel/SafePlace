import logging

import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import azure.functions as func
import json

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    tableService = TableService(account_name='sosstor', account_key='cus0jXl35Wf9bAqyTYLqtBqtTywQIMoN3tyi3VqMahE+k1EnG9KO8lah1T/8crBTP3IWP6BsdPvpRD5O8TWvNQ==')
    req_body = req.get_json() ## req_body has username
    usernameJson = json.loads(str(req_body).replace("'","\""))
    username_given = usernameJson['username']
    longitude = usernameJson['long']
    latitude =  usernameJson['lat']
    name_given = usernameJson['name']
    phone_given = usernameJson['phone']
    print(username_given)
    print(longitude)
    print(latitude)
    locationTask = {'PartitionKey': str(username_given), 'RowKey': str(username_given), 'longitude': str(longitude), 'latitude': str(latitude), 'name': name_given, 'phone': phone_given}
    tableService.insert_entity("locations", locationTask)
    print("Inserted location")
    
    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.",
             status_code=200
        )
