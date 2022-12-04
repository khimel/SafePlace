import logging

import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import json

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    tableService = TableService(account_name='sosstor', account_key='#')
    req_body = req.get_json() ## req_body has username and password to check
    loginInfo = json.loads(str(req_body).replace("'","\""))
    username_given = loginInfo['username']
    password_given = loginInfo['password']
    password_found = ""
    tasks = tableService.query_entities("users", filter=f"PartitionKey eq 'PKuser' and username eq '{username_given}'")
    foundUser = []
    for task in tasks:
        if task is not None:
            password_found = task.password
            foundUser.append({"username":task.RowKey, "name":task.name, "phone": task.phone})
    
    if password_found == password_given:
        return func.HttpResponse(
            json.dumps(foundUser),
             status_code=200
        )
    else:
        return func.HttpResponse(
            json.dumps([]),
             status_code=200
        )
