import logging
import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import azure.functions as func
import json

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    tableService = TableService(account_name='sosstor', account_key='#')
    req_body = req.get_json() ## req_body has username
    usernameJson = json.loads(str(req_body).replace("'","\""))
    username_given = usernameJson['username']
    longitude = usernameJson['long']
    latitude =  usernameJson['lat']
    name_given = usernameJson['name']
    phone_given = usernameJson['phone']

    locationTask = {'PartitionKey': str(username_given), 'RowKey': str(username_given), 'longitude': str(longitude), 'latitude': str(latitude), 'name': name_given, 'phone': phone_given}
    tableService.insert_entity("locations", locationTask)

    
    return func.HttpResponse(
             "This HTTP triggered function executed successfully.",
             status_code=200
        )
