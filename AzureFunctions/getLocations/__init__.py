import logging
import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import json

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    tableService = TableService(account_name='sosstor', account_key='#')
    tasks = tableService.query_entities("locations")
    foundLocations = []
    for task in tasks:
        if task is not None:
            foundLocations.append({"username":task.RowKey, "longitude": task.longitude, "latitude": task.latitude, "name":task.name, "phone": task.phone})
    if len(foundLocations) != 0:
        return func.HttpResponse(
            json.dumps(foundLocations),
             status_code=200
        )

    return func.HttpResponse(
             "This HTTP triggered function executed successfully.",
             status_code=200
    )
