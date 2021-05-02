from boto3.dynamodb.conditions import Key, Attr
from lib.utils.db_utils import get_dynamo_table, get_dynamo_client, construct_dynamo_type_dict, \
    get_resolved_dynamo_table_name, dynamo_deserialize
from lib.utils.datetime import now
from lib.settings.settings import TableNames
import sys


def create_filtering_exp_using_set(attribute_values, attribute_name):
    """
    Create a filter expression for reading multiple objects at the same time

    Args:
        attribute_values: a list of values that applies to the field
        attribute_name: string, the field on which the filter applies

    Returns:
        A valid dynamoDb expression
    """
    filtering_exp = None
    for key in attribute_values:
        if filtering_exp is None:
            filtering_exp = Attr(attribute_name).eq(key)
        else:
            filtering_exp = filtering_exp | Attr(attribute_name).eq(key)
    return filtering_exp


def scan_table(table_name, filtering_exp=None):
    """
    :param table_name: table name without the platform and env prefixes.
    - 'AssetTable'
    :param filter_exp: dynamodb filter expression
    - Attr('assetStatus').eq('{}'.format(AssetStatus.FINAL.name)) & Attr('isValid').eq(True)
    :return: List of valid items
    """
    if filtering_exp:
        return scan_table_all(table_name, filtering_exp & Attr('isValid').eq(True))
    return scan_table_all(table_name, Attr('isValid').eq(True))

def scan_table_all(table_name, filtering_exp=None):
    """
    Perform a scan operation on table.
    While using this function, if isValid is not set in the filtering_exp, caller receives:
    VALID as well as INVALID records.

    DynamoDB table are paginated hence it is not guaranteed that this
    scan will be able to grab all the data in table.

    In order to scan the table page by page, we use a loop as indicated bellow.

    More details can be found here:
    https://www.tutorialspoint.com/dynamodb/dynamodb_scan.htm


    Args:
        dynamodb_resource: a dynamo DB resource instance
        table_name: the name of the table we want to scan
        filtering_exp: A valid dynamodb filter expression
        - Attr('assetStatus').eq('{}'.format('FINAL')) & Attr('isValid').eq(True)


    Returns:
        List of Items
    """
    table = get_dynamo_table(table_name)
    if filtering_exp is not None:
        response = table.scan(FilterExpression=filtering_exp)
    else:
        response = table.scan()
    # Get items
    items = response['Items']
    while response.get('LastEvaluatedKey'):
        response = table.scan(ExclusiveStartKey=response['LastEvaluatedKey'], ConsistentRead=True)
        items += response['Items']
    return items


def get_item(table_name, item_key: dict):
    try:
        table = get_dynamo_table(table_name)
        return table.get_item(Key=item_key, ConsistentRead=True)['Item']
    except:
        import traceback
        import sys
        traceback.print_tb(sys.exc_info()[2], limit=5)
        return None


def get_items_by_id(table_name: TableNames, ids: set):
    return get_items(table_name, list(map(lambda idx: construct_dynamo_type_dict({'id': idx}), ids)))


def get_dict_items_by_id(table_name: TableNames, ids: set):
    ret_list = get_items_by_id(table_name, ids)
    ret_dict = {}
    for rec in ret_list:
        ret_dict[rec['id']] = rec
    return ret_dict


def get_items(table_name: TableNames, item_keys: list):
    dynamodb = get_dynamo_client()
    resolved_table_name = get_resolved_dynamo_table_name(table_name)
    result = dynamodb.batch_get_item(RequestItems={
        resolved_table_name: {'Keys': item_keys, 'ConsistentRead': True}
    })['Responses'][resolved_table_name]
    return list(map(lambda r: dynamo_deserialize(r), result))


def invalidate_record(table_name: TableNames, item_key: dict, version: int, last_updated_by: str):
    """
    Fake delete a record by setting isValid to false.
    The caller must have the latest version of the record.
    This check prevents races, as a part of the optimistic write technique, often also
    referred to as CAS (compare and swap).
    """
    if table_name is None or item_key is None or version is None or last_updated_by is None:
        raise ValueError("Either of these is None: table_name[{}], item_key[{}], version[{}], lastUpdatedBy[{}]"
                         .format(table_name, item_key, version, last_updated_by))

    table = get_dynamo_table(table_name)
    update_expression = 'SET {0} = :{0}, {1} = :{1}, {2} = :{2}'.format('isValid', 'version', 'lastUpdatedBy')
    new_item = {':isValid': False, ':version': version + 1, ':lastUpdatedBy': last_updated_by}
    response = table.update_item(
        Key=item_key,
        UpdateExpression=update_expression,
        ConditionExpression=Attr('version').eq(version),
        ExpressionAttributeValues=new_item,
        ReturnValues="ALL_NEW"
    )
    return response


def construct_update_expression(item_key: dict, update_dictionary: dict):
    if 'version' not in update_dictionary.keys():
        raise ValueError("Cannot update record without version information: {}", update_dictionary)

    if 'lastUpdatedBy' not in update_dictionary.keys():
        raise ValueError("Cannot update record without lastUpdatedBy information: {}", update_dictionary)

    # override version and just in case someone forgets to update lastUpdatedDateTime
    curr_ver = update_dictionary['version']
    update_dictionary['version'] = curr_ver + 1
    update_dictionary['lastUpdatedDateTime'] = now()

    # TODO: Create helper for identifying meta data of a table item and utility library
    # TODO: TableItemMeta(id, isValid, version, lastUpdatedDateTime, lastUpdatedBy)

    # remove item_key
    # item_key cannot be updated.
    keys_to_skip = set(item_key.keys())

    update_expression_builder = []
    expression_attr_values = {}
    for key, value in update_dictionary.items():
        if key not in keys_to_skip:
            update_expression_builder.append('{0} = :{0}'.format(key))
            expression_attr_values[':{}'.format(key)] = value
    update_expression = 'SET ' + ','.join(update_expression_builder)
    return update_expression, expression_attr_values


def update_record(table_name, item_key: dict, update_dictionary: dict):
    """
    update dynamo DB by dictionary automatically. Don't need to write dynamodb expression as this
    function will help you write it.

    Args:
        dynamodb_resource: a dynamo DB resource instance
        table_name: the name of the table we want to scan
        key: the key for update
        update_dictionary: the dictionary for update


    Returns:
        response from dynamo DB
    """
    (update_expression, expression_attr_values) = construct_update_expression(item_key, update_dictionary)
    table = get_dynamo_table(table_name)
    response = table.update_item(
        Key=item_key,
        UpdateExpression=update_expression,
        ConditionExpression=Attr('version').eq(update_dictionary['version'] - 1),
        ExpressionAttributeValues=expression_attr_values,
        ReturnValues="ALL_NEW"
    )
    return response


def query_table(table: TableNames, query_params: dict, filter_exp = None):
    if filter_exp is None:
        return query_table_all(table, query_params, Attr('isValid').eq(True))
    else:
        return query_table_all(table, query_params, filter_exp & Attr('isValid').eq(True))


def query_table_all(table: TableNames, query_params: dict, filter_exp = None):
    """
    A table can be queried for primary index or secondary indexes.
    For all others use scan_table.
    query_table is much faster as it uses indexes for query, unlike
    scan_table which happens to be a full table scan.
    :param table:
    :param query_params:
    :return:
    """
    key_condition = None
    for k,v in query_params.items():
        if key_condition:
            key_condition = key_condition & Key(k).eq(v)
        else:
            key_condition = Key(k).eq(v)
    response = get_dynamo_table(table).query(
        KeyConditionExpression=key_condition, FilterExpression=filter_exp
    )
    items = response['Items']
    return items
