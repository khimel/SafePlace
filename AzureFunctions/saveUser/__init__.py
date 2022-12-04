import logging

import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import json

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    
    tableService = TableService(account_name='sosstor', account_key='#')

    counterEntity = dict(tableService.get_entity("users", "PKuser", "RKcounter"))
    counter = int(counterEntity["counter"])
    counter += 1
    counterEntity["counter"] = str(counter)
    tableService.update_entity("users", counterEntity)

    req_body = req.get_json() ## req_body has the user info
    userInfo = json.loads(str(req_body).replace("'","\""))
    userInfo["RowKey"] = str(counter)

    tableService.insert_entity("users", userInfo, timeout=None)
    
    return func.HttpResponse(f'Hi {userInfo}')



