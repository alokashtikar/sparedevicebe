import json
from lib.utils.common import get_email_from_gateway_event, get_user_id_from_gateway_event, get_username_from_gateway_event
import logging
import uuid

from botocore.exceptions import ClientError
from boto3.dynamodb.conditions import Attr
from decimal import Decimal

from lib.settings.settings import TableNames
from lib.utils.db_utils import get_dynamo_table, get_resolved_dynamo_table_name
from lib.utils.server import generate_success_response, generate_failure_response, generate_failure_response_with_message
from lib.utils.datetime import now
from lib.utils.common import required, convert_to_dynamo_compatible, require_valid_values
from lib.utils.table_access_utils import scan_table, get_item, invalidate_record

import traceback
import sys

log = logging.getLogger()
log.setLevel(logging.INFO)


def get_all_items(event, context):
    user_id = None
    try:
        user_id = get_user_id_from_gateway_event(event)
    except:
        log.info('Not signed in!')

    latitude = Decimal(0)
    longitude = Decimal(0)
    query_params = False
    try:
        latitude = Decimal(float(event['queryStringParameters']['latitude']))
        longitude = Decimal(float(event['queryStringParameters']['longitude']))
        object_type = event['queryStringParameters']['type']
        query_params = True
    except:
        log.info('Bad query params')

    try:
        if query_params:
            one = Decimal(1.0)
            filter_exp = Attr('latitude').gt(latitude - one) &\
                         Attr('latitude').lt(latitude + one) &\
                         Attr('longitude').gt(longitude - one) &\
                         Attr('longitude').lt(longitude + one) &\
                         Attr('type').eq(object_type)
            results = scan_table(TableNames.LISTING_TABLE, filter_exp)
        else:
            results = scan_table(TableNames.LISTING_TABLE)
        # user_results = []
        # other_results = []
        final_results = []
        for r in results:
            r['proximity'] = (latitude - r['latitude']) ** 2 + (longitude - r['longitude']) ** 2
            r['longitude'] = r['latitude'] = Decimal(0)
            # if r['userId'] == user_id:
            #     user_results.append(r)
            # else:
            #     other_results.append(r)
            final_results.append(r)
        # final_results = user_results + other_results

    except ClientError as e:
        traceback.print_tb(sys.exc_info()[2], limit=5)
        log.error(sys.exc_info())
        raise e(sys.exc_info())
    else:
        response = generate_success_response(final_results)
        log.info(response)
        return response



def open_handler(event, context):
    log.info(event)
    if event['path'] == '/open/items':
        if event['httpMethod'] == 'GET':
            return get_all_items(event, context)
    return {
        "statusCode": 200,
        "body": json.dumps(event['path'])
    }




def create_item(event, context):
    item_unique_id = str(uuid.uuid1())
    try:
        data = event
        req_data = convert_to_dynamo_compatible(data['body'])
        user_id = get_user_id_from_gateway_event(event)
        email = get_email_from_gateway_event(event)
        username = get_username_from_gateway_event(event)

        required(req_data['item'], {'description', 'type', 'latitude', 'longitude', 'name', 'city'})

        item = {
            'id': item_unique_id,
            'isValid': True,
            'version': 0,
            'lastUpdatedBy': user_id,
            'lastUpdatedDateTime': now(),
            'description': req_data['item']['description'],
            'type': req_data['item']['type'],
            'latitude': req_data['item']['latitude'],
            'longitude': req_data['item']['longitude'],
            'username': username,
            'userId': user_id
        }

        # copy rest of the fields
        remaining_keys = set(req_data['item'].keys()) - set(item.keys())
        for k in remaining_keys:
            item[k] = req_data['item'][k]

        table = get_dynamo_table(TableNames.LISTING_TABLE)
        log.info(get_resolved_dynamo_table_name(TableNames.LISTING_TABLE))
        query_response = table.put_item(Item=item)
        log.info(json.dumps(query_response))
    except (KeyError, ClientError) as e:
        traceback.print_tb(sys.exc_info()[2], limit=5)
        log.error(sys.exc_info())
        raise e(sys.exc_info())
    else:
        response = generate_success_response(item)
        log.info(response)
        return response


def get_user_items(event, context):
    try:
        user_id = get_user_id_from_gateway_event(event)
        email = get_email_from_gateway_event(event)
        username = get_username_from_gateway_event(event)
        filter_exp = Attr('userId').eq(user_id)
        response = scan_table(TableNames.LISTING_TABLE, filter_exp)
        log.info(response)
    except (KeyError, ClientError) as e:
        traceback.print_tb(sys.exc_info()[2], limit=5)
        log.error(sys.exc_info())
        raise e(sys.exc_info())
    else:
        response = generate_success_response(response)
        log.info(response)
        return response


def delete_user_item(event, context):
    try:
        key = {'id': event['queryStringParameters']['id']}
        item = get_item(TableNames.LISTING_TABLE, key)
        query_response = invalidate_record(TableNames.LISTING_TABLE, key, item['version'], get_user_id_from_gateway_event(event))
        log.info(query_response)
    except (KeyError, ClientError) as e:
        traceback.print_tb(sys.exc_info()[2], limit=5)
        log.error(sys.exc_info())
        raise e(sys.exc_info())
    else:
        response = generate_success_response(query_response)
        log.info(response)
        return response


def user_handler(event, context):
    log.info(event)

    if event['path'] == '/user/items':
        if event['httpMethod'] == 'POST':
            return create_item(event, context)
        if event['httpMethod'] == 'GET':
            return get_user_items(event, context)
        if event['httpMethod'] == 'DELETE':
            return delete_user_item(event, context)

    return generate_success_response(json.dumps({'path': event['path'], 'email': get_email_from_gateway_event(event),
                            'object': event['body']}))

