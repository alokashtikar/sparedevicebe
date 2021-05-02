
######## API #########
resource "aws_api_gateway_rest_api" "api" {
  name        = "${title(lower(var.company_name))} ${var.env} API"
}

######## Resource open ########
resource "aws_api_gateway_resource" "open" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
   path_part   = "open"
}

resource "aws_api_gateway_resource" "open_proxy" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_resource.open.id
   path_part   = "{resources+}"
}

######## Methods ########
resource "aws_api_gateway_method" "open_proxy" {
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.open_proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

######## Integration ########
resource "aws_api_gateway_integration" "open_lambda" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_method.open_proxy.resource_id
   http_method = aws_api_gateway_method.open_proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.open_proxy.invoke_arn
}

######## Resource user ########
resource "aws_api_gateway_resource" "user" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
   path_part   = "user"
}

resource "aws_api_gateway_resource" "user_proxy" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   parent_id   = aws_api_gateway_resource.user.id
   path_part   = "{resources+}"
}

######## Methods ########
resource "aws_api_gateway_method" "user_proxy" {
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.user_proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

######## Integration ########
resource "aws_api_gateway_integration" "user_lambda" {
   rest_api_id = aws_api_gateway_rest_api.api.id
   resource_id = aws_api_gateway_method.user_proxy.resource_id
   http_method = aws_api_gateway_method.user_proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.user_proxy.invoke_arn

   request_templates = {
    "application/xml" = <<EOF
{
   "statusCode": 200,
   "body" : $input.json('$')
}
EOF
  }
}

######## OPTIONS #########
resource "aws_api_gateway_method" "api_root_OPTIONS" {
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_rest_api.api.root_resource_id
   http_method   = "OPTIONS"
   authorization = "NONE"
}

resource "aws_api_gateway_method_response" "api_root_OPTIONS_response" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_rest_api.api.root_resource_id
    http_method   = aws_api_gateway_method.api_root_OPTIONS.http_method
    status_code   = "200"
    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = true,
      "method.response.header.Access-Control-Allow-Methods" = true,
      "method.response.header.Access-Control-Allow-Origin" = true
    }
    depends_on = ["aws_api_gateway_method.api_root_OPTIONS"]
}

resource "aws_api_gateway_integration" "api_root_OPTIONS_integration" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_rest_api.api.root_resource_id
    http_method   = aws_api_gateway_method.api_root_OPTIONS.http_method
    type          = "MOCK"
    depends_on = ["aws_api_gateway_method.api_root_OPTIONS"]
}

resource "aws_api_gateway_integration_response" "api_root_OPTIONS" {
    rest_api_id   = aws_api_gateway_rest_api.api.id
    resource_id   = aws_api_gateway_rest_api.api.root_resource_id
    http_method   = aws_api_gateway_method.api_root_OPTIONS.http_method
    status_code   = aws_api_gateway_method_response.api_root_OPTIONS_response.status_code
    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
      "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = [aws_api_gateway_method_response.api_root_OPTIONS_response,
    aws_api_gateway_integration.api_root_OPTIONS_integration]
}

########## deployment ########
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "${var.env}"
  depends_on = [
     aws_api_gateway_integration.api_root_OPTIONS_integration,
   ]
}

####### key, Usage plan and stages ########
resource "aws_api_gateway_api_key" "api" {
  name = "${title(lower(var.company_name))} ${var.env} API"
}

resource "aws_api_gateway_usage_plan" "usage_plan" {
  name         = "${title(lower(var.company_name))} ${var.env} UsagePlan"


//  quota_settings {
//    limit  = 20
//    offset = 2
//    period = "WEEK"
//  }
//
//  throttle_settings {
//    burst_limit = 5
//    rate_limit  = 10
//  }

  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_deployment.deployment.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "api" {
  key_id        = aws_api_gateway_api_key.api.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usage_plan.id
}
