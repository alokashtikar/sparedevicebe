import json
from lib.utils.common import get_email_from_gateway_event
from lib.utils.server import generate_success_response
import logging

log = logging.getLogger()
log.setLevel(logging.INFO)

def open_handler(event, context):
    log.info(event)
    return {
        "statusCode": 200,
        "body": json.dumps(event['path'])
    }


def user_handler(event, context):
    print(event)
    log.info(event)
    return generate_success_response(json.dumps({'path': event['path'], 'email': get_email_from_gateway_event(event),
                            'object': event['body']}))

