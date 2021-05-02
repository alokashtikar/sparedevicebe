import hashlib
from decimal import Decimal
from lib.settings.settings import AccountType, OrderDirection, PLATFORM_USER_ID, BITZ_CASH_ACCOUNT_ID


def encode_base32(id: int):
    """
    base32 encode provided by python library depends upon the series of bytes.
    We do not depend on that implementation.
    1) It does not consider int as ints and hence does not treat -ve integers correctly.
    2) Due to the indeterministic endianness of ints on different hardwares, we have no
       guarantee of the sequencing of bytes
    :param id: integer
    :return: string
    """
    base32_characters = '0123456789ABCDEFGHJKLMNPQRSTUWXZ'
    base = 32
    base_bits = 5
    # choosing these characters is based on the inspiration of base58 encode
    # implemented by bitcoin.

    res = str()
    val = abs(id)

    while(val > (base-1)):
        remainder = val & (base-1)
        res += base32_characters[remainder]
        val = val >> base_bits
    if val >= 0:
        res += base32_characters[val]

    if id < 0:
        res += '-'

    # reversing the string, that is the correct answer
    return res[::-1]


def get_order_book_id(asset_id: str, direction: OrderDirection):
    """
    Single md5 hash suffices, as there is no cryptographic threat for these IDs
    The external world will never get these IDs.
    :param asset_id:
    :param direction:
    :return:
    """
    bytes_to_hash = bytes('{}:{}'.format(asset_id, direction.name), 'ascii')
    m = hashlib.md5()
    m.update(bytes_to_hash)
    return m.hexdigest()


def get_aggregated_order_book_id(asset_id: str, quantity: Decimal, price: Decimal, direction: OrderDirection):
    """
    Single md5 hash suffices.
    :param asset_id:
    :param quantity:
    :param price:
    :param direction:
    :return:
    """
    bytes_to_hash = bytes('{}:{}:{}:{}'.format(asset_id, str(quantity), str(price), direction.name), 'ascii')
    m = hashlib.md5()
    m.update(bytes_to_hash)
    return m.hexdigest()


def get_account_id(account_type: AccountType, base: str):
    """
    typical double hash implementation:  dh = h(h(b)||b)
    our double hash implementation: dh = h(h(accountType||:||b)||b)
    we are using md5 hash as it fits the size of UUID, hence storage to DB will be optimized in most cases
    :param account_type: taken in to create extra nonce for different account id numbers
    :param base: user_id usually
    :return: a very huge integer
    """
    bytes_to_hash = bytes('{}:{}'.format(account_type.name, base), 'ascii')
    m = hashlib.md5()
    m.update(bytes_to_hash)
    # double hash h(b)||b
    dm = hashlib.md5()
    dm.update(bytes(m.hexdigest(),'ascii') + base.encode('ascii'))
    # with getting the hex and then converting to int using base 16 we dont have to worry about
    # endianness of the hardware.
    hex_id = dm.hexdigest()
    return int(hex_id, 16)


def pretty_id(id: int):
    return encode_base32(id)[0:8]


def get_cash_account_id(user_id: str):
    """
    BITZ cash account id is generated from the user_id of the investor.
    :param user_id: string in the uuid format, taken from the user's registration
    :return: first 8 characters of Base32 encoded double hash of 'Cash:' + 'user_id'
    """
    if user_id == PLATFORM_USER_ID:
        return BITZ_CASH_ACCOUNT_ID
    return pretty_id(get_account_id(AccountType.CASH, user_id))


def get_pledge_account_id(user_id: str, asset_id: str):
    """
    BITZ pledge account id is generated from the user_id of the investor.
    :param user_id: string in the uuid format, taken from the user's registration
    :return: first 8 characters of Base32 encoded double hash of 'Pledge:user_id:asset_id'
    """
    return pretty_id(get_account_id(AccountType.PLEDGE, '{}:{}'.format(user_id, asset_id)))


def get_shares_account_id(user_id: str, asset_id: str):
    """
    BITZ shares account id is generated from the user_id of the investor.
    :param user_id: string in the uuid format, taken from the user's registration
    :return: first 8 characters of Base32 encoded double hash of 'Shares:' + 'user_id'
    """
    return pretty_id(get_account_id(AccountType.SHARES, '{}:{}'.format(user_id, asset_id)))


def get_asset_cash_account_id(asset_id: str):
    """
    Every asset has its own cash account id where it maintains the asset purchase and management fees.
    When the asset is being purchased, there are no management fees. When the asset is purchased, and if
    purchased at a lower price than the raised money, then money may be returned to investors, or used
    as a sinking fund for the maintenance / up keep of the asset. The maintenance fees for the asset is
    collected either from the yield as a percentage or is charged to the investor as a draw-down notice.
    :param asset_id: will be treated as a user id for the asset.
    :return:
    """
    return get_cash_account_id(asset_id)


def get_escrow_account_id(asset_id: str):
    """
    BITZ escrow account id is generated from the asset id. Escrow account has the money which generated
    or yield from the asset. However, this is pre-tax, pre-commision, pre-maintenance-fees money
    and therefore, is not given to investors as yield disbursement as it is.
    :param asset_id: string in the uuid format, taken from the asset's registration
    :return: first 8 characters of Base32 encoded double hash of 'Escrow:1:asset_id'
    """
    return pretty_id(get_account_id(AccountType.ESCROW, '{}:{}'.format(PLATFORM_USER_ID, asset_id)))


def get_investor_yield_disbursement_id(disbursement_id: str, user_id: str):
    """
    For a particular disbursement request, there cannot be multiple cash updates for a user.
    To restrict this, the simplest way is to create an id for investor_yield_disbursement.
    :param disbursement_id:
    :param user_id:
    :return:
    """
    return hex(get_account_id(AccountType.YIELD, '{}:{}'.format(disbursement_id, user_id)))
