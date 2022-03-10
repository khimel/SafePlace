import logging

import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import json


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    tableService = TableService(account_name='sosstor', account_key='cus0jXl35Wf9bAqyTYLqtBqtTywQIMoN3tyi3VqMahE+k1EnG9KO8lah1T/8crBTP3IWP6BsdPvpRD5O8TWvNQ==')
    req_body = req.get_json() ## req_body has username + contact info
    givenJson = json.loads(str(req_body).replace("'","\""))
    username_given = givenJson['username']
    contactName = givenJson['name']
 
    tableService.delete_entity('contacts', str(username_given), str(contactName))

    return func.HttpResponse(
             "This HTTP triggered function executed successfully.",
             status_code=200
        )
