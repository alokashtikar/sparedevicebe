/*
Tables managed:

  PledgeOrderTable
  AssetTable
  AccountLedgerTable
  AccountMasterTable
  AddFundReferenceTable
  FundAccountTable
  KYCStatusTable
  PledgeLedgerTable
  SharesLedgerTable
  SharesMasterTable

added 03072019
  OrderBookEventLog
  OrderTable
  PledgeTable
  TemporaryTokensTable
  UserProfileTable

*/

####################
# order_management
resource "aws_dynamodb_table" "PledgeOrderTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_PledgeOrderTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}


####################
# asset_management
resource "aws_dynamodb_table" "AssetTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_AssetTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

####################
# asset_management
resource "aws_dynamodb_table" "AssetAllotmentTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_AssetAllotmentTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "YieldDisbursementTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_YieldDisbursementTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

####################
# account_management
resource "aws_dynamodb_table" "InvestorYieldDisbursementTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_InvestorYieldDisbursementTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "AccountLedgerTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_AccountLedgerTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "WithdrawFundReferenceTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_WithdrawFundReferenceTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "AccountMasterTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_AccountMasterTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "AddFundReferenceTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_AddFundReferenceTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "FundAccountTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_FundAccountTable"
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "KYCStatusTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_KYCStatusTable"
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }
  billing_mode = "PAY_PER_REQUEST"
}
resource "aws_dynamodb_table" "PledgeLedgerTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_PledgeLedgerTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "SharesLedgerTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_SharesLedgerTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "SharesMasterTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_SharesMasterTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "OrderBookEventLog" {
  name           = "${title(lower(var.company_name))}_${var.env}_OrderBookEventLog"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"


  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "OrderTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_OrderTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "OrderTableAudit" {
  name           = "${title(lower(var.company_name))}_${var.env}_OrderTableAudit"
  hash_key       = "id"
  range_key      = "version"

  attribute {
    name = "id"
    type = "S"
  }
  attribute {
    name = "version"
    type = "N"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "PledgeTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_PledgeTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "TemporaryTokensTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_TemporaryTokensTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "UserProfileTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_UserProfileTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "OrderBookTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_OrderBookTable"
  hash_key       = "assetId"
  range_key      = "orderId"

  attribute {
    name = "assetId"
    type = "S"
  }
 attribute {
    name = "orderId"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "TradeBookEventLog" {
  name           = "${title(lower(var.company_name))}_${var.env}_TradeBookEventLog"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"


  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "TradeCashSettlementEventLog" {
  name           = "${title(lower(var.company_name))}_${var.env}_TradeCashSettlementEventLog"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "TradeSharesSettlementEventLog" {
  name           = "${title(lower(var.company_name))}_${var.env}_TradeSharesSettlementEventLog"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"


  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "TradeCashSettlementTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_TradeCashSettlementTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "TradeSharesSettlementTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_TradeSharesSettlementTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "OrderFillTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_OrderFillTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_dynamodb_table" "OrderAmendmentEventLog" {
  name           = "${title(lower(var.company_name))}_${var.env}_OrderAmendmentEventLog"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"
  
  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}

#########
# Adding data
//resource "aws_dynamodb_table_item" "AccountMasterTable" {
//  hash_key = "${aws_dynamodb_table.AccountMasterTable.hash_key}"
//  item = <<ITEM
//{
//  "id": {"S": "1"},
//  "isValid": {"BOOL": true},
//  "version": {"N": "0"},
//  "lastUpdatedBy": {"S": "setup"},
//  "lastUpdatedDateTime": {"N": "0"},
//  "balanceAmount": {"N": "0"}
//}
//ITEM
//  table_name = "${aws_dynamodb_table.AccountMasterTable.name}"
//}