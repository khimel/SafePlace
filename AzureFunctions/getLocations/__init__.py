import logging

import azure.functions as func
from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import json


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')
    tableService = TableService(account_name='sosstor', account_key='cus0jXl35Wf9bAqyTYLqtBqtTywQIMoN3tyi3VqMahE+k1EnG9KO8lah1T/8crBTP3IWP6BsdPvpRD5O8TWvNQ==')
    tasks = tableService.query_entities("locations")
    foundLocations = []
    for task in tasks:
        if task is not None:
            foundLocations.append({"username":task.RowKey, "longitude": task.longitude, "latitude": task.latitude, "name":task.name, "phone": task.phone})
    print(foundLocations)
    if len(foundLocations) != 0:
        return func.HttpResponse(
            json.dumps(foundLocations),
             status_code=200
        )
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
