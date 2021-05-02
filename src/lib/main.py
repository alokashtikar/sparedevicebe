import json


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
        "body": json.dumps(event['path'])
    }
