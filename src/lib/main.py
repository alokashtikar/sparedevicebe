import json
from lib.utils.common import get_email_from_gateway_event

def open_handler(event, context):
    print(event['path'])
    return {
        "statusCode": 200,
        "body": json.dumps(event['path'])
    }


def user_handler(event, context):
    print(event['path'])
    return {
        "statusCode": 200,
        "body": json.dumps({'path': event['path'], 'email': get_email_from_gateway_event(event)})
    }
