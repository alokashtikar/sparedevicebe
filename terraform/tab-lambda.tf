
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
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir = "${var.lambda_src_dir}"
  output_path = "${var.lambda_function_package_file}"
}

resource "aws_s3_bucket" "lambda_s3" {
	force_destroy = true
}

resource "aws_s3_bucket_object" "v1" {
  key        = "v1.0.0"
  bucket     = aws_s3_bucket.lambda_s3.id
	source     = data.archive_file.lambda_zip.output_path
  etag       = data.archive_file.lambda_zip.output_base64sha256
}

####################
# open
resource "aws_lambda_function" "open" {
  memory_size=1792
  s3_bucket        = aws_s3_bucket.lambda_s3.id
	s3_key           = aws_s3_bucket_object.v1.id
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name = "${title(lower(var.company_name))}_${var.env}_open"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/main.open_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# user
resource "aws_lambda_function" "user" {
  memory_size=1792
  s3_bucket        = aws_s3_bucket.lambda_s3.id
	s3_key           = aws_s3_bucket_object.v1.id
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name = "${title(lower(var.company_name))}_${var.env}_user"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/main.user_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# open_proxy
resource "aws_lambda_function" "open_proxy" {
  memory_size=1792
  s3_bucket        = aws_s3_bucket.lambda_s3.id
	s3_key           = aws_s3_bucket_object.v1.id
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name = "${title(lower(var.company_name))}_${var.env}_open_proxy"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/main.open_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}

####################
# user_proxy
resource "aws_lambda_function" "user_proxy" {
  memory_size=1792
  s3_bucket        = aws_s3_bucket.lambda_s3.id
	s3_key           = aws_s3_bucket_object.v1.id
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name = "${title(lower(var.company_name))}_${var.env}_user_proxy"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "lib/main.user_handler"
  timeout       = 6

  runtime = "python3.7"
  layers = ["${aws_lambda_layer_version.boto3.arn}"]

  environment {
    variables = "${var.lambda_env_vars}"
  }
}


resource "aws_lambda_permission" "user" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${title(lower(var.company_name))}_${var.env}_user_proxy"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}


resource "aws_lambda_permission" "open" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${title(lower(var.company_name))}_${var.env}_open_proxy"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}
