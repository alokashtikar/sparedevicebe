import logging
from boto3.dynamodb.types import TypeSerializer, TypeDeserializer
from lib.utils.db_utils import get_resolved_dynamo_table_name, construct_dynamo_type_dict, get_dynamo_client
from lib.settings.settings import TableNames
from lib.utils.table_access_utils import construct_update_expression

log = logging.getLogger()
log.setLevel(logging.INFO)


def construct_update_table_dict(table_name: TableNames, item_key: dict, update_dict: dict):
    """
    The update dict that needs to be set for transaction_write_items:
    https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/dynamodb.html#DynamoDB.Client.transact_write_items

    ConditionExpression is a string as per below:

        condition-expression ::=
              operand comparator operand
            | operand BETWEEN operand AND operand
            | operand IN ( operand (',' operand (, ...) ))
            | function
            | condition AND condition
            | condition OR condition
            | NOT condition
            | ( condition )

        comparator ::=
            =
            | <>
            | <
            | <=
            | >
            | >=

        function ::=
            attribute_exists (path)
            | attribute_not_exists (path)
            | attribute_type (path, type)
            | begins_with (path, substr)
            | contains (path, operand)
            | size (path)
    """
    curr_version = update_dict['version']
    (update_expression, expression_attr_values) = construct_update_expression(item_key, update_dict)
    expression_attr_values[':current_version'] = curr_version
    res = {
        'Update': {
            'Key': construct_dynamo_type_dict(item_key),
            'TableName': get_resolved_dynamo_table_name(table_name),
            'UpdateExpression': update_expression,
            'ConditionExpression': 'version = :current_version',
            'ExpressionAttributeValues': construct_dynamo_type_dict(expression_attr_values)
        }
    }
    return res


def construct_put_table_dict(table_name: TableNames, item: dict):
    return {
        'Put': {
            'Item': construct_dynamo_type_dict(item),
            'TableName': get_resolved_dynamo_table_name(table_name)
        }
    }


def deconstruct_from_dynamo_event(event):
    """
        {'Records':
        [
            {
            'eventID': 'f2552522f15ac49bae72cc751973ac34',
            'eventName': 'MODIFY',
            'eventVersion': '1.1',
            'eventSource': 'aws:dynamodb',
            'awsRegion': 'us-east-2',
            'dynamodb': {
                'ApproximateCreatedDateTime': 1559833090.0,
                'Keys': {
                    'id': {'S': 'b722c9e0-839e-11e9-8ff3-3a9ce2fecb55'}
                    },
                'NewImage': {... object of the new image to be "deserialized"...},
                'SequenceNumber': '27489800000000001219353382',
                'SizeBytes': 304,
                'StreamViewType': 'NEW_IMAGE'
                },
            'eventSourceARN': 'arn:aws:dynamodb:us-east-2:475285711284:table/Tab_DEV_AddFundReferenceTable/stream/2019-06-03T12:14:21.372'
            }
        ]
    }
    :param event:
    :return:
    """
    deserializer = TypeDeserializer()
    res = []
    for r in event['Records']:
        if 'dynamodb' in r.keys():
            res.append(deserializer.deserialize({'M': r['dynamodb']['NewImage']}))
    return res


def transact_write(items):
    dynamodb = get_dynamo_client()
    tx_write_res = dynamodb.transact_write_items(TransactItems=items)
    if tx_write_res['ResponseMetadata']['HTTPStatusCode'] != 200:
        raise ValueError('Could not perform a transactional update')
    log.info('Successful transact_write: {}'.format(items))

