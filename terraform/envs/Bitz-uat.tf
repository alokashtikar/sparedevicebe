#common variables
variable "company_name" {
  default = "BITZ"
}

variable "company_name_for_notifications" {
  default = "BITZ"
}

variable "env"  {
  default = "UAT"
}

variable "lambda_env_vars" {
  type    = map
  default = {
    BITZ_ENV = "UAT"
    BITZ_PLATFORM = "Bitz"
    GOOGLE_APPLICATION_CREDENTIALS = "./lib/notifications_service/firebase.json"
    BITZ_FEATURE = "3"
  }
}

variable "aws_region" {
  default = "eu-west-2"
}

variable "env_name" {
  default = "BITZ-UAT"
}

variable "s3_private_bucket_name" {
  default = "bitz-uat-pii"
}

variable "s3_public_bucket_name"  {
  default = "bitz-uat-asset-objects"
}

variable "s3_bo_bucket_name"  {
  default = "bitz-uat-bo"
}

variable "s3_hni_bucket_name"  {
  default = "bitz-uat-hni"
}

variable "iam_lambda_policy_file"  {
  default = "./bitz-iam-lambda-policy.json"
}

variable "iam_identity_backoffice_authenticated_policy_file"  {
  default = "./bitz-iam-cognito-identity-authenticated-policy.json"
}

variable "iam_identity_backoffice_unauthenticated_policy_file"  {
  default = "./bitz-iam-cognito-identity-unauthenticated-policy.json"
}

variable "yield_disbursement_rule_schedule_expression"  {
  default = "cron(5 0 * * ? *)"
}

variable "dynamodb_point_in_time_recovery"  {
  default = "true"
}

variable "lambda_src_dir"  {
  default = "./lambda-src/"
}

variable "lambda_function_package_file"  {
  default = "./bitz-prod-lambda.zip"
}

variable "cognito_user_pool_investors_domain" {
  default = "bitz-uat-hni"
}

variable "cognito_user_pool_backoffice_domain" {
  default = "bitz-uat-bo"
}

variable "cognito_client_investors_callback" {
  default = "https://demo-investor.bitz-solutions.com/cognito"
}

variable "cognito_client_investors_signout" {
  default = "https://demo-investor.bitz-solutions.com"
}

variable "cognito_client_backoffice_callback" {
  default = "https://demo-backoffice.bitz-solutions.com/cognito"
}

variable "cognito_client_backoffice_signout" {
  default = "https://demo-backoffice.bitz-solutions.com"
}

variable "bitz_backoffice_domain" {
  default = "demo-backoffice.bitz-solutions.com"
}


/*
variable "bitz_cert"  {
  default = "./certs/STAR_ec-internal_com.crt"
}
variable "bitz_chain"  {
  default = "./certs/STAR_ec-internal_com.chain"
}

variable "bitz_key"  {
  default = "./certs/STAR_ec-internal_com.key"
}
*/



//resource "aws_lambda_event_source_mapping" "dbstreamUserProfileEventUpdate" {
//  event_source_arn = "${aws_dynamodb_table.UserProfileTable.stream_arn}"
//  function_name     = "${aws_lambda_function.dbstreamUserProfileEventUpdate.arn}"
//  starting_position = "LATEST"
//}
//
//resource "aws_lambda_function" "dbstreamUserProfileEventUpdate" {
//  memory_size=1792
//  filename      = "${var.lambda_function_package_file}"
//  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
//  function_name = "${title(lower(var.company_name))}_${var.env}_dbstreamUserProfileEventUpdate"
//  role          = "${aws_iam_role.lambda-role.arn}"
//  handler       = "lib/user_management/automated_kyc_approval.user_profile_update_handler"
//  timeout       = 20
//
//  runtime = "python3.7"
//  layers = ["${aws_lambda_layer_version.boto3.arn}"]
//
//  environment {
//    variables = {
//      BITZ_ENV = "${var.env}"
//      BITZ_PLATFORM = "${title(lower(var.company_name))}"
//    }
//  }
//}
//
//
//resource "aws_lambda_event_source_mapping" "dbstreamAddFundReferenceUpdate" {
//  event_source_arn = "${aws_dynamodb_table.AddFundReferenceTable.stream_arn}"
//  function_name     = "${aws_lambda_function.dbstreamAddFundReferenceUpdate.arn}"
//  starting_position = "LATEST"
//}
//
//resource "aws_lambda_function" "dbstreamAddFundReferenceUpdate" {
//  memory_size=1792
//  filename      = "${var.lambda_function_package_file}"
//  source_code_hash = "${data.archive_file.lambda-zip.output_base64sha256}"
//  function_name = "${title(lower(var.company_name))}_${var.env}_dbstreamAddFundReferenceUpdate"
//  role          = "${aws_iam_role.lambda-role.arn}"
//  handler       = "lib/account_service/automated_payment_approval.add_fund_update_handler"
//  timeout       = 20
//
//  runtime = "python3.7"
//  layers = ["${aws_lambda_layer_version.boto3.arn}"]
//
//  environment {
//    variables = {
//      BITZ_ENV = "${var.env}"
//      BITZ_PLATFORM = "${title(lower(var.company_name))}"
//    }
//  }
//}


variable "bitz_cert_arn"  {
  default = "arn:aws:acm:us-east-1:464007601209:certificate/d542a021-563b-42df-b9d8-a515dfa37673"
}

provider "aws" {
  profile    = "${var.env_name}"
  region     = "${var.aws_region}"
}

provider "aws" {
  region = "us-east-1"
  alias = "acm"
}

provider "aws" {
  alias   = "cloudfront"
  region  = "us-east-1" // NOTE: This needs to be us-east-1 for WAFv2 on scope CLOUDFRONT
}

resource "random_id" "stage" {
  byte_length = 8
}

terraform {
    backend "s3" {
        bucket = "bitz-uat-terraform"
        key = "bitz-uat"
        region = "eu-west-2"
        encrypt = false
    }
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "3.27.0"
      }
    }
}
