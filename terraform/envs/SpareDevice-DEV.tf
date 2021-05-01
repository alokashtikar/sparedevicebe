#common variables
variable "company_name" {
  default = "SpareDevice"
}

variable "company_name_for_notifications" {
  default = "SpareDevice"
}

variable "env"  {
  default = "DEV"
}

variable "lambda_env_vars" {
  type    = map
  default = {
    SPAREDEVICE_ENV = "DEV"
    SPAREDEVICE_PLATFORM = "SpareDevice"
  }
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "env_name" {
  default = "SpareDevice-DEV"
}

variable "s3_public_bucket_name"  {
  default = "sparedevice-dev-asset-objects"
}

variable "s3_webapp_bucket_name"  {
  default = "sparedevice-dev-bo"
}

variable "iam_lambda_policy_file"  {
  default = "./iam-lambda-policy.json"
}

variable "iam_identity_backoffice_authenticated_policy_file"  {
  default = "./iam-cognito-identity-authenticated-policy.json"
}

variable "iam_identity_backoffice_unauthenticated_policy_file"  {
  default = "./iam-cognito-identity-unauthenticated-policy.json"
}

variable "dynamodb_point_in_time_recovery"  {
  default = "true"
}

variable "lambda_src_dir"  {
  default = "./lambda-src/"
}

variable "lambda_function_package_file"  {
  default = "./SpareDevice-prod-lambda.zip"
}

variable "cognito_user_pool_domain" {
  default = "sparedevice-dev"
}

variable "cognito_client_callback" {
  default = "http://localhost:4200/cognito"
}

variable "cognito_client_signout" {
  default = "http://localhost:4200"
}

variable "sparedevice_webapp_domain" {
  default = "sparedevice-dev-bo.ec-internal.com"
}

variable "sparedevice_cert_arn"  {
  default = "arn:aws:acm:us-east-1:550043475145:certificate/6ed88948-b993-4b0a-bef1-7ce555f884cb"
}


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
        bucket = "sparedevice-dev-terraform"
        key = "sparedevice-dev"
        region = "ap-south-1"
        encrypt = false
    }
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "3.27.0"
      }
    }
}
