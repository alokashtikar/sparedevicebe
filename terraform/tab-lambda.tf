/*
Lambda Functions managed:

  boCreateAsset
  boGetAddFunds
  boUpdateAddFund
  boUpdateAssetStatus
  boViewAssets
  dbstreamAddFundUpdate
  dbstreamAssetUpdate
  hniAddFund
  hniCreatePledgeOrder
  hniGetCashAccount
  hniGetPortfolio
  hniViewAsset
  hniViewAssets

Added 03072019
  hniUploadPIIData
  boUpdateAsset
  boGetPIIData
  boGetAllCashTransactions
  fetchFile
  hniCreateOrder
  boGetUserProfile
  boGetAllUserProfiles
  boUpdateUserProfile
  hniGetPIIData
  hniGetUserProfile
*/


####################
# upload Boto3 layer
resource "aws_lambda_layer_version" "boto3" {
  filename   = "Boto3Latest.zip"
  layer_name = "Boto3Latest"

  compatible_runtimes = ["python3.7"]
}

####################
# upload firebase layer
resource "aws_lambda_layer_version" "firebase" {
  filename   = "firebase_lambda_layer.zip"
  layer_name = "firebase_admin_430"

  compatible_runtimes = ["python3.7"]
}

####################
# upload firestore layer
resource "aws_lambda_layer_version" "firestore" {
  filename   = "firestore_lambda_layer.zip"
  layer_name = "firestore_181"

  compatible_runtimes = ["python3.7"]
}

####################
#create lambda function zip
data "archive_file" "lambda-zip" {
  type        = "zip"
  source_dir = "${var.lambda_src_dir}"
  output_path = "${var.lambda_function_package_file}"
}

####################
# create lambda events from db streams (triggers)
resource "aws_lambda_event_source_mapping" "AddFundReferenceTable" {
  event_source_arn = "${aws_dynamodb_table.AddFundReferenceTable.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamAddFundUpdate.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "dbstreamAssetUpdate" {
  event_source_arn = "${aws_dynamodb_table.AssetTable.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamAssetUpdate.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "dbstreamOrderBookEventUpdate" {
  event_source_arn = "${aws_dynamodb_table.OrderBookEventLog.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamOrderBookEventUpdate.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "dbstreamOrderTableUpdate" {
  event_source_arn = "${aws_dynamodb_table.OrderTable.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamOrderTableUpdate.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "dbstreamTradeBookEventUpdate" {
  event_source_arn = "${aws_dynamodb_table.TradeBookEventLog.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamTradeBookEventUpdate.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "dbstreamTradeSharesSettlementEventUpdate" {
  event_source_arn = "${aws_dynamodb_table.TradeSharesSettlementEventLog.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamTradeSharesSettlementEventUpdate.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_event_source_mapping" "dbstreamTradeCashSettlementEventUpdate" {
  event_source_arn = "${aws_dynamodb_table.TradeCashSettlementEventLog.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamTradeCashSettlementEventUpdate.arn}"
  starting_position = "LATEST"
}

####################
# boCreateAsset
resource "aws_lambda_function" "boCreateAsset" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boCreateAsset"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/create_asset_impl.create_asset_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}


####################
# boGetAddFunds
resource "aws_lambda_function" "boGetAddFunds" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boGetAddFunds"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/bo_get_add_fund_list_impl.get_add_funds_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boGetAddFunds
resource "aws_lambda_function" "boUpdateAddFund" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boUpdateAddFund"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/bo_update_add_fund_impl.update_add_fund_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boUpdateAssetStatus
resource "aws_lambda_function" "boUpdateAssetStatus" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boUpdateAssetStatus"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/update_asset_status_impl.update_asset_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boViewAssets
resource "aws_lambda_function" "boViewAssets" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boViewAssets"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/view_asset_impl.view_asset_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# dbstreamAddFundUpdate
resource "aws_lambda_function" "dbstreamAddFundUpdate" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_dbstreamAddFundUpdate"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/fund_reference_table_update_impl.fund_update_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# dbstreamAssetUpdate
resource "aws_lambda_function" "dbstreamAssetUpdate" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_dbstreamAssetUpdate"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/asset_table_update_impl.asset_update_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# dbstreamOrderTableUpdate
resource "aws_lambda_function" "dbstreamOrderTableUpdate" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_dbstreamOrderTableUpdate"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/order_management/order_table_audit_impl.order_table_audit_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniAddFund
resource "aws_lambda_function" "hniAddFund" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniAddFund"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/hni_add_fund_impl.add_fund_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

resource "aws_lambda_function" "hniAddNotificationToken" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniAddNotificationToken"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/user_management/update_profile_impl.hni_add_notification_token"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniCreateWithdrawFund
resource "aws_lambda_function" "hniCreateWithdrawFund" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniCreateWithdrawFund"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/hni_withdraw_fund_impl.withdraw_fund_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniGetWithdrawFunds
resource "aws_lambda_function" "hniGetWithdrawFunds" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniGetWithdrawFunds"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/hni_view_withdraw_fund_requests_impl.hni_view_withdraw_funds_request_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boGetWithdrawFunds
resource "aws_lambda_function" "boGetWithdrawFunds" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boGetWithdrawFunds"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/bo_view_withdraw_fund_list_impl.bo_view_withdraw_funds_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boUpdateWithdrawFund
resource "aws_lambda_function" "boUpdateWithdrawFund" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boUpdateWithdrawFund"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/bo_update_withdraw_fund_impl.update_withdraw_fund_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniCreatePledgeOrder
resource "aws_lambda_function" "hniCreatePledgeOrder" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniCreatePledgeOrder"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/order_management/create_pledge_order.hni_create_pledge_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniGetCashAccount
resource "aws_lambda_function" "hniGetCashAccount" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniGetCashAccount"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/hni_get_cash_account_impl.hni_get_cash_account_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniGetPortfolio
resource "aws_lambda_function" "hniGetPortfolio" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniGetPortfolio"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/order_management/hni_view_portfolio_impl.hni_view_portfolio_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniViewAsset
resource "aws_lambda_function" "hniViewAsset" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniViewAsset"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/hni_view_assets_impl.hni_get_asset"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniViewAssets
resource "aws_lambda_function" "hniViewAssets" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniViewAssets"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/hni_view_assets_impl.hni_view_asset_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniUploadPIIData
resource "aws_lambda_function" "hniUploadPIIData" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniUploadPIIData"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/user_management/update_profile_impl.hni_update_kyc_documents"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boUpdateAsset
resource "aws_lambda_function" "boUpdateAsset" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boUpdateAsset"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/update_asset_status_impl.update_asset_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boGetPIIData
resource "aws_lambda_function" "boGetPIIData" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boGetPIIData"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/user_management/update_profile_impl.bo_view_kyc_document"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boGetAllCashTransactions
resource "aws_lambda_function" "boGetAllCashTransactions" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boGetAllCashTransactions"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/bo_get_cash_account_impl.bo_get_all_cash_transactions_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boGetAllPledges
resource "aws_lambda_function" "boGetAllPledges" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boGetAllPledges"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/order_management/bo_get_pledge_list_impl.get_pledges_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# fetchFile
resource "aws_lambda_function" "fetchFile" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_fetchFile"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/user_management/update_profile_impl.fetch_file"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniCreateOrder
resource "aws_lambda_function" "hniCreateOrder" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniCreateOrder"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/order_management/create_order.hni_create_order_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boGetUserProfile
resource "aws_lambda_function" "boGetUserProfile" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boGetUserProfile"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/user_management/bo_get_user_profile.bo_get_user_profile_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boGetAllUserProfiles
resource "aws_lambda_function" "boGetAllUserProfiles" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boGetAllUserProfiles"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/user_management/bo_get_user_profile.bo_get_all_user_profiles_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boUpdateUserProfile
resource "aws_lambda_function" "boUpdateUserProfile" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boUpdateUserProfile"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/user_management/bo_get_user_profile.bo_update_user_profile_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniGetPIIData
resource "aws_lambda_function" "hniGetPIIData" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniGetPIIData"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/user_management/update_profile_impl.hni_view_kyc_document"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniGetUserProfile
resource "aws_lambda_function" "hniGetUserProfile" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniGetUserProfile"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/user_management/hni_get_user_profile.hni_get_user_profile_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boCreateCashTransaction
resource "aws_lambda_function" "boCreateCashTransaction" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boCreateCashTransaction"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/bo_create_cash_transaction_impl.bo_create_cash_transaction_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniGetOpenOrdersForAsset
resource "aws_lambda_function" "hniGetOpenOrdersForAsset" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniGetOpenOrdersForAsset"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/trading/hni_view_order_book_impl.hni_view_order_book_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniGetAddFundRequests
resource "aws_lambda_function" "hniGetAddFundRequests" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniGetAddFundRequests"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/hni_add_fund_impl.hni_get_add_fund_requests_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# dbstreamOrderBookEventUpdate
resource "aws_lambda_function" "dbstreamOrderBookEventUpdate" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_dbstreamOrderBookEventUpdate"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/trading/process_order_book_event_impl.order_book_event_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# dbstreamTradeBookEventUpdate
resource "aws_lambda_function" "dbstreamTradeBookEventUpdate" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_dbstreamTradeBookEventUpdate"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/trading/process_trade_book_event_impl.trade_book_event_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# dbstreamTradeSharesSettlementEventUpdate
resource "aws_lambda_function" "dbstreamTradeSharesSettlementEventUpdate" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_dbstreamTradeSharesSettlementEventUpdate"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/trading/process_trade_shares_settlement_event_impl.trade_shares_settlement_event_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# dbstreamTradeCashSettlementEventUpdate
resource "aws_lambda_function" "dbstreamTradeCashSettlementEventUpdate" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_dbstreamTradeCashSettlementEventUpdate"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/trading/process_trade_cash_settlement_event_impl.trade_cash_settlement_event_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boCreateYieldDisbursement
resource "aws_lambda_function" "boCreateYieldDisbursement" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boCreateYieldDisbursement"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/bo_yield_disbursement_impl.bo_create_yield_disbursement_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boGetYieldDisbursements
resource "aws_lambda_function" "boGetYieldDisbursements" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boGetYieldDisbursements"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/bo_yield_disbursement_impl.bo_get_yield_disbursements_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# boDeleteYieldDisbursement
resource "aws_lambda_function" "boDeleteYieldDisbursement" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_boDeleteYieldDisbursement"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/asset_management/bo_yield_disbursement_impl.bo_delete_yield_disbursement_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniGetOrders
resource "aws_lambda_function" "hniGetOrders" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniGetOrders"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/order_management/hni_view_orders_impl.hni_view_orders_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniGetOrderDetail
resource "aws_lambda_function" "hniGetOrderDetail" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniGetOrderDetail"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/order_management/hni_view_orders_impl.hni_view_order_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# hniCancelOrder
resource "aws_lambda_function" "hniCancelOrder" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_hniCancelOrder"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/order_management/cancel_order.hni_cancel_order_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# yieldDisbursementTimerEvent
resource "aws_lambda_function" "yieldDisbursementTimerEvent" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_yieldDisbursementTimerEvent"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/account_service/yield_disbursement_impl.yield_disbursement_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# Cloudwatch event
resource "aws_cloudwatch_event_rule" "yield_disbursement_rule" {
  name = "${title(lower(var.company_name))}_${var.env}_yieldDisbursementRule"

  depends_on = [
    "aws_lambda_function.yieldDisbursementTimerEvent"
  ]
  schedule_expression = "${var.yield_disbursement_rule_schedule_expression}"
}

resource "aws_cloudwatch_event_target" "yieldDisbursementTimerEvent" {

  rule = "${aws_cloudwatch_event_rule.yield_disbursement_rule.name}"
  arn = "${aws_lambda_function.yieldDisbursementTimerEvent.arn}"
}

resource "aws_lambda_permission" "yield_disbursement_rule_permission" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.yieldDisbursementTimerEvent.function_name}"
  principal = "events.amazonaws.com"
  source_arn = "${aws_cloudwatch_event_rule.yield_disbursement_rule.arn}"
}

resource "aws_lambda_event_source_mapping" "dbstreamUserProfileEventUpdateNotification" {
  event_source_arn = "${aws_dynamodb_table.UserProfileTable.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamUserProfileEventUpdateNotification.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_function" "dbstreamUserProfileEventUpdateNotification" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_KYCNotification"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/notifications_service/kyc_notification.lambda_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}","${aws_lambda_layer_version.firebase.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

resource "aws_lambda_event_source_mapping" "dbstreamTradeBookEventUpdateNotification" {
  event_source_arn = "${aws_dynamodb_table.TradeBookEventLog.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamTradeBookEventUpdateNotification.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_function" "dbstreamTradeBookEventUpdateNotification" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_TradeBookRealtimeSyncNotification"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/notifications_service/market_ticker.lambda_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}","${aws_lambda_layer_version.firestore.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

resource "aws_lambda_event_source_mapping" "dbstreamOrderBookTableUpdateNotification" {
  event_source_arn = "${aws_dynamodb_table.OrderBookTable.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamOrderBookTableUpdateNotification.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_function" "dbstreamOrderBookTableUpdateNotification" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_OrderBookRealtimeSyncNotification"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/notifications_service/order_book_ticker.lambda_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}","${aws_lambda_layer_version.firestore.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

resource "aws_lambda_event_source_mapping" "dbstreamAssetUpdateRealTimeSync" {
  event_source_arn = "${aws_dynamodb_table.AssetTable.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamAssetUpdateRealTimeSync.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_function" "dbstreamAssetUpdateRealTimeSync" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_AssetUpdateRealTimeSyncNotification"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/notifications_service/asset_ticker.lambda_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}","${aws_lambda_layer_version.firestore.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

resource "aws_lambda_event_source_mapping" "dbstreamOrderUpdateNotification" {
  event_source_arn = "${aws_dynamodb_table.OrderTableAudit.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamOrderUpdateNotification.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_function" "dbstreamOrderUpdateNotification" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_OrderRealtimeSyncNotification"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/notifications_service/order_update_notification.lambda_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}","${aws_lambda_layer_version.firebase.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

resource "aws_lambda_event_source_mapping" "dbstreamAddFundUpdateNotification" {
  event_source_arn = "${aws_dynamodb_table.AddFundReferenceTable.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamAddFundUpdateNotification.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_function" "dbstreamAddFundUpdateNotification" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_AddFundSyncNotification"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/notifications_service/cash_top_up_notification.lambda_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}","${aws_lambda_layer_version.firebase.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

resource "aws_lambda_event_source_mapping" "dbstreamWithdrawUpdateNotification" {
  event_source_arn = "${aws_dynamodb_table.WithdrawFundReferenceTable.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamWithdrawUpdateNotification.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_function" "dbstreamWithdrawUpdateNotification" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_WithdrawSyncNotification"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/notifications_service/cash_withdraw_notification.lambda_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}","${aws_lambda_layer_version.firebase.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

resource "aws_lambda_event_source_mapping" "dbstreamSharesAllotmentNotification" {
  event_source_arn = "${aws_dynamodb_table.AssetAllotmentTable.stream_arn}"
  function_name     = "${aws_lambda_function.dbstreamSharesAllotmentNotification.arn}"
  starting_position = "LATEST"
}

resource "aws_lambda_function" "dbstreamSharesAllotmentNotification" {
  memory_size=1792
  filename      = "${var.lambda_function_package_file}"
  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
  function_name = "${title(lower(var.company_name))}_${var.env}_SharesAllotmentNotification"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/notifications_service/shares_allotment_notification.lambda_handler"
  timeout       = 20

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}","${aws_lambda_layer_version.firebase.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}
