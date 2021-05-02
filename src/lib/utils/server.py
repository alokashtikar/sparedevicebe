import json

from lib.utils.common import DecimalEncoder


def generate_success_response(item):
    response = {
        "statusCode": 200,
        "body": json.dumps(item, cls=DecimalEncoder),
        "headers": {
            "Access-Control-Allow-Origin": "*"
        }
    }
    return response


def generate_failure_response_with_message(err_msg: str):
    return generate_failure_response({'errorMessage': err_msg})


def generate_failure_response(err: dict):
    response = {
        "statusCode": 500,
        "body": json.dumps(err, cls=DecimalEncoder),
        "headers": {
            "Access-Control-Allow-Origin": "*"
        }
    }
    return response

#def generate_unauthorized_response(err):
#    response = {
#        "statusCode": 401,
#        "body": json.dumps(err, cls=DecimalEncoder),
#        "headers": {
#            "Access-Control-Allow-Origin": "*"
#        }
#    }
#    return response
