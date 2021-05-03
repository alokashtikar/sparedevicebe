import os
from enum import Enum, unique

USE_ENV = os.getenv('SPAREDEVICE_ENV', 'LOCAL')

LOCAL_DYNAMO_DB = os.getenv('LOCAL_DYNAMO_DB_URL', 'http://localhost:8000')

PLATFORM_DB_ENDPOINT = {
    'PROD': None,
    'UAT': None,
    'LOCAL': LOCAL_DYNAMO_DB,
    'QA': None,
    'DEV': None
}

TEMP_TOKEN_EXPIRATION_DURATION = 10000  # 10 secs

DEFAULT_ORDER_EXPIRATION_DURATION = 10 * 365 * 24 * 60 * 60 * 1000  # default expiration is 10 yrs from the time of creation of order


@unique
class TableNames(Enum):
    """
    Storing stable names at a common place, so that chances of 'spelling mistakes'
    and thereby errors reduce
    """
    LISTING_TABLE = 'ListingTable'


KEY_OVERRIDE_FOR_TABLE = {
    # TableNames.ORDER_BOOK_TABLE: {'assetId', 'orderId'},
    # TableNames.ORDER_TABLE_AUDIT: {'id', 'version'},
    'DEFAULT': {'id'}
}

