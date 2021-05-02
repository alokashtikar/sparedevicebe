import os
from enum import Enum, unique

@unique
class TableNames(Enum):
    """
    Storing stable names at a common place, so that chances of 'spelling mistakes'
    and thereby errors reduce
    """
    LISTING_TABLE = 'ListingTable'

