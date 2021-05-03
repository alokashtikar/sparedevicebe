import os

import boto3
from boto3.dynamodb.types import TypeSerializer, TypeDeserializer

from ..settings.settings import USE_ENV, PLATFORM_DB_ENDPOINT, TableNames, KEY_OVERRIDE_FOR_TABLE


def get_resolved_dynamo_table_name(table_name: TableNames):
    env = get_env()
    platform = get_platform()
    return "{}_{}_{}".format(platform, env, table_name.value)


def get_dynamo_table(table_name: TableNames):
    tn = get_resolved_dynamo_table_name(table_name)
    dynamoDb = get_dynamo_resource()
    return dynamoDb.Table(tn)


# TODO for all different environments, need to supply create dynamo
def get_dynamo_resource():
    return boto3.resource('dynamodb', endpoint_url=PLATFORM_DB_ENDPOINT[USE_ENV])


def get_dynamo_client():
    return boto3.client('dynamodb', endpoint_url=PLATFORM_DB_ENDPOINT[USE_ENV])

def get_env():
    return os.getenv("SPAREDEVICE_ENV", "LOCAL")

def get_platform():
    return os.getenv("SPAREDEVICE_PLATFORM", "SpareDevice")

def get_dynamo_instance():
    """
    get a connexion to dynamoDB depending on the environment

    :return:
    """
    dynamodb = boto3.resource('dynamodb', endpoint_url=PLATFORM_DB_ENDPOINT[USE_ENV])
    return dynamodb

def construct_dynamo_type_dict(d: dict):
    """
    DynamoDB transactions need a different way of specifying transaction.
    The structure has to be recursively implemented as:
                    'string': {
                        'S': 'string',
                        'N': 'string',
                        'B': b'bytes',
                        'SS': [
                            'string',
                        ],
                        'NS': [
                            'string',
                        ],
                        'BS': [
                            b'bytes',
                        ],
                        'M': {
                            'string': {'... recursive ...'}
                        },
                        'L': [
                            {'... recursive ...'},
                        ],
                        'NULL': True|False,
                        'BOOL': True|False
                    }
    https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/dynamodb.html#DynamoDB.Client.transact_write_items
    TypeSerializer and TypeDeserializer needs to be used to convert to appropriate representations for DynamoDB.
    serialize(d)['M'] has been used in line with the documentation.
    """
    serializer = TypeSerializer()
    return serializer.serialize(d)['M']


def dynamo_deserialize(object: dict):
    d = TypeDeserializer()
    return d.deserialize({'M': object})


def get_key_fields(table):
    if table in KEY_OVERRIDE_FOR_TABLE.keys():
        return KEY_OVERRIDE_FOR_TABLE[table]
    return KEY_OVERRIDE_FOR_TABLE['DEFAULT']

