import logging
 
import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import json


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    tableService = TableService(account_name='sosstor', account_key='#')
    req_body = req.get_json() ## req_body has username
    usernameJson = json.loads(str(req_body).replace("'","\""))
    username_given = usernameJson['username']


    tasks = tableService.query_entities("contacts", filter=f"PartitionKey eq '{username_given}'")
    foundContacts = []
    for task in tasks:
        if task is not None:
            foundContacts.append({"name":task.RowKey, "email": task.email})

    if len(foundContacts) != 0:
        return func.HttpResponse(
            json.dumps(foundContacts),
             status_code=200
        )

    return func.HttpResponse(
             "This HTTP triggered function executed successfully.",
             status_code=200
        )

        
