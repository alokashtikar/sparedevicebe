import os
from enum import Enum, unique

USE_ENV = os.getenv('BITZ_ENV', 'LOCAL')

LOCAL_DYNAMO_DB = os.getenv('LOCAL_DYNAMO_DB_URL', 'http://localhost:8000')

PLATFORM_DB_ENDPOINT = {
    'PROD': None,
    'UAT': None,
    'LOCAL': LOCAL_DYNAMO_DB,
    'QA': None,
    'DEV': None
}

# hard coded platform's cash account id, for ease of supportability.
BITZ_CASH_ACCOUNT_ID = '1'
NO_CASH_ACCOUNT_ID = '0'
PLATFORM_USER_ID = '1'

TEMP_TOKEN_EXPIRATION_DURATION = 10000  # 10 secs

DEFAULT_ORDER_EXPIRATION_DURATION = 10 * 365 * 24 * 60 * 60 * 1000  # default expiration is 10 yrs from the time of creation of order

# the maximum number of records to return from the top of the order book
ORDER_BOOK_DEPTH = 5

CURRENT_SCHEMA_VERSION: str = '2.0.0'

@unique
class PledgeStatus(Enum):
    PENDING = 1
    ACCEPTED = 2
    DECLINED = 3
    CANCELLED = 4
    MATURED = 5

@unique
class Market(Enum):
    """
    Enum class for market types
    """
    PRIMARY = 1
    SECONDARY = 2
    UNKNOWN = 3


@unique
class AccountType(Enum):
    CASH = "Cash"
    PLEDGE = "Pledge"
    SHARES = "Shares"
    ESCROW = "Escrow"
    YIELD = "Yield"


@unique
class SharesStatus(Enum):
    ALLOTMENT = 1  # allotment in progress
    REGISTERED = 2  # live for secondary market
    SUSPENDED = 3
    BURNED = 4


@unique
class AddFundStatus(Enum):
    PENDING = 1
    RECEIVED = 2
    ACCOUNT_UPDATED = 3


@unique
class WithdrawFundStatus(Enum):
    PENDING = 1
    PROCESSED = 2
    REJECTED = 3


@unique
class AssetStatus(Enum):
    """
    Asset Status
    """
    DRAFT = 1
    LIVE = 2  # Live for pledging
    ACQUISITION = 3  # Acquisition in progress
    ACQUIRED = 4   # ready for trading
    SUSPENDED = 5  # Property is taken off the HNI view


@unique
class TableNames(Enum):
    """
    Storing stable names at a common place, so that chances of 'spelling mistakes'
    and thereby errors reduce
    """
    ASSET_TABLE = 'AssetTable'
    ASSET_ALLOTMENT_TABLE = 'AssetAllotmentTable'
    ADD_FUND_REFERENCE_TABLE = 'AddFundReferenceTable'
    ACCOUNT_MASTER_TABLE = 'AccountMasterTable'
    ACCOUNT_LEDGER_TABLE = 'AccountLedgerTable'
    PLEDGE_LEDGER_TABLE = 'PledgeLedgerTable'
    PLEDGE_ORDER_TABLE = 'PledgeOrderTable'
    SHARES_LEDGER_TABLE = 'SharesLedgerTable'
    SHARES_MASTER_TABLE = 'SharesMasterTable'
    ORDER_TABLE = 'OrderTable'
    ORDER_BOOK_EVENT_LOG = 'OrderBookEventLog'
    USER_PROFILE_TABLE = 'UserProfileTable'
    TEMP_TOKENS_TABLE = 'TemporaryTokensTable'
    ORDER_BOOK_TABLE = 'OrderBookTable'
    TRADE_BOOK_EVENT_LOG = 'TradeBookEventLog'
    TRADE_CASH_SETTLEMENT_EVENT_LOG = 'TradeCashSettlementEventLog'
    TRADE_CASH_SETTLEMENT_TABLE = 'TradeCashSettlementTable'
    TRADE_SHARES_SETTLEMENT_EVENT_LOG = 'TradeSharesSettlementEventLog'
    TRADE_SHARES_SETTLEMENT_TABLE = 'TradeSharesSettlementTable'
    ORDER_FILL_TABLE = 'OrderFillTable'
    YIELD_DISBURSEMENT_TABLE = 'YieldDisbursementTable'
    INVESTOR_YIELD_DISBURSEMENT_TABLE = 'InvestorYieldDisbursementTable'
    WITHDRAW_FUND_REFERENCE_TABLE = 'WithdrawFundReferenceTable'
    ORDER_AMENDMENT_EVENT_LOG = 'OrderAmendmentEventLog'
    ORDER_TABLE_AUDIT = 'OrderTableAudit'


@unique
class KYCStatus(Enum):
    UNVERIFIED = 1
    PENDING = 2
    VERIFIED = 3
    SUSPENDED = 4


@unique
class CashLedgerTransactionType(Enum):
    FUND_RECEIVED = 1
    PLEDGE = 2
    BUY_ORDER_ACCEPTED = 3
    SELL_ORDER_ACCEPTED = 4
    YIELD_DISBURSEMENT = 5
    YIELD_RECEIPT = 6
    TRADE_SETTLEMENT = 7
    YIELD_RECEIPT_REVERTED = 8
    WITHDRAW_REQUEST = 9
    WITHDRAW_PROCESSED = 10
    WITHDRAW_REJECTED = 11
    ORDER_CANCEL_REIMBURSEMENT = 12
    BUY_TRADE_REIMBURSEMENT = 13


@unique
class PledgeLedgerTransactionType(Enum):
    GO_LIVE = 1
    PLEDGE = 2
    WITHDRAW_PLEDGE = 3


@unique
class SharesLedgerTransactionType(Enum):
    CREATION = 1
    TRANSFER = 2
    SUSPEND = 3
    FREEZE = 4
    SELL_ORDER_ACCEPTED = 5
    TRADE_SETTLEMENT = 6


@unique
class PledgeStatus(Enum):
    PENDING = 1
    ACCEPTED = 2
    EXECUTED = 3
    REJECTED = 4
    WITHDRAWN = 5


@unique
class OrderType(Enum):
    LIMIT = 1
    MARKET = 2


@unique
class OrderDirection(Enum):
    BUY = 1
    SELL = 2


@unique
class OrderStatus(Enum):
    PENDING = 1
    PENDING_CANCEL = 2
    ACCEPTED = 3
    REJECTED = 4
    CANCELLED = 5
    CANCEL_REJECTED = 6
    FILLED = 7
    PARTIALLY_FILLED = 8
    EXECUTED = 9
    EXPIRED = 10


@unique
class OrderBookEventType(Enum):
    CREATED = 1
    CANCEL_REQUEST = 2


@unique
class CashSettlementStatus(Enum):
    SETTLEMENT_SUCCESSFUL = 0
    SETTLEMENT_FAILED = 1


@unique
class SharesSettlementStatus(Enum):
    SETTLEMENT_SUCCESSFUL = 0
    SETTLEMENT_FAILED = 1


@unique
class YieldDisbursementStatus(Enum):
    ESCROW_ACCOUNT_UPDATED = 0
    SHARES_OWNERSHIP_ESTABLISHED = 1
    DISBURSEMENT_COMPLETE = 2
    DISBURSEMENT_FAILED = 3


@unique
class InvestorYieldDisbursementStatus(Enum):
    ASSIGNED = 0
    DISBURSEMENT_COMPLETE = 1
    DISBURSEMENT_FAILED = 2


@unique
class OrderAmendmentType(Enum):  # DONOT USE THIS LIKE OTHER ENUMS, This is intended to be used along with bitwise operators
    CANCEL = 1
    AMEND_QUANTITY = 2
    AMEND_PRICE = 4
    AMEND_ORDER_TYPE = 8


@unique
class OrderAmendmentStatus(Enum):
    REQUESTED = 0
    PROCESSED = 1
    REJECTED = 2


KEY_OVERRIDE_FOR_TABLE = {
    TableNames.ORDER_BOOK_TABLE: {'assetId', 'orderId'},
    TableNames.ORDER_TABLE_AUDIT: {'id', 'version'},
    'DEFAULT': {'id'}
}

