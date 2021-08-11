import logging

from azure.cosmosdb.table.tableservice import TableService
from azure.cosmosdb.table.models import Entity
import azure.functions as func
import json
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail

## gets username (in danger) + location
def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    tableService = TableService(account_name='sosstor', account_key='cus0jXl35Wf9bAqyTYLqtBqtTywQIMoN3tyi3VqMahE+k1EnG9KO8lah1T/8crBTP3IWP6BsdPvpRD5O8TWvNQ==')
    req_body = req.get_json() ## req_body has username
    usernameJson = json.loads(str(req_body).replace("'","\""))
    username_given = usernameJson['username']
    name_given = usernameJson['name']
    phone_given = usernameJson['phone']
    print(username_given)
    
    tasks = tableService.query_entities("contacts", filter=f"PartitionKey eq '{username_given}'")
    foundContacts = []
    for task in tasks:
        if task is not None:
            foundContacts.append({"name":task.RowKey, "email": task.email})
    print(foundContacts)
    value = f"Hey Can you please check on {username_given}?"
    for c in foundContacts:
        message = Mail(
            from_email='khmhamad1999@gmail.com',
            to_emails=c["email"],
            subject='SOS',
            html_content=f'Hey, Can you please check on {name_given}? Try calling on: {phone_given}')
        try:
            sg = SendGridAPIClient("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")
            response = sg.send(message)
            print(response.status_code)
            print(response.body)
            print(response.headers)
        except Exception as e:
            print(e.message)

    return func.HttpResponse(f"Sent")
