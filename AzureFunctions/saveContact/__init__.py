import logging
import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import json


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    tableService = TableService(account_name='sosstor', account_key='#')
    req_body = req.get_json() ## req_body has username + contact info
    givenJson = json.loads(str(req_body).replace("'","\""))
    username_given = givenJson['username']
    contactName = givenJson['name']
    contactEmail = givenJson['email']

    task = {'PartitionKey': str(username_given), 'RowKey': str(contactName), 'email': str(contactEmail)}
    tableService.insert_entity("contacts", task)

    return func.HttpResponse(
             "This HTTP triggered function executed successfully.",
             status_code=200
        )
