
######## Investor API #########
resource "aws_api_gateway_rest_api" "investor_api" {
  name        = "${title(lower(var.company_name))} ${var.env} Investor"
  description = "This set of APIs are to do with investor operations on the Bitz platform"
}

######## Investor OPTIONS #########
resource "aws_api_gateway_method" "investor_api_root_OPTIONS" {
   rest_api_id   = aws_api_gateway_rest_api.investor_api.id
   resource_id   = aws_api_gateway_rest_api.investor_api.root_resource_id
   http_method   = "OPTIONS"
   authorization = "NONE"
}

resource "aws_api_gateway_method_response" "investor_api_root_OPTIONS_response" {
    rest_api_id   = aws_api_gateway_rest_api.investor_api.id
    resource_id   = aws_api_gateway_rest_api.investor_api.root_resource_id
    http_method   = aws_api_gateway_method.investor_api_root_OPTIONS.http_method
    status_code   = "200"
    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = true,
      "method.response.header.Access-Control-Allow-Methods" = true,
      "method.response.header.Access-Control-Allow-Origin" = true
    }
    depends_on = ["aws_api_gateway_method.investor_api_root_OPTIONS"]
}

resource "aws_api_gateway_integration" "investor_api_root_OPTIONS_integration" {
    rest_api_id   = aws_api_gateway_rest_api.investor_api.id
    resource_id   = aws_api_gateway_rest_api.investor_api.root_resource_id
    http_method   = aws_api_gateway_method.investor_api_root_OPTIONS.http_method
    type          = "MOCK"
    depends_on = ["aws_api_gateway_method.investor_api_root_OPTIONS"]
}

resource "aws_api_gateway_integration_response" "investor_api_root_OPTIONS" {
    rest_api_id   = aws_api_gateway_rest_api.investor_api.id
    resource_id   = aws_api_gateway_rest_api.investor_api.root_resource_id
    http_method   = aws_api_gateway_method.investor_api_root_OPTIONS.http_method
    status_code   = aws_api_gateway_method_response.investor_api_root_OPTIONS_response.status_code
    response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
      "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
    }
    depends_on = [aws_api_gateway_method_response.investor_api_root_OPTIONS_response,
    aws_api_gateway_integration.investor_api_root_OPTIONS_integration]
}

########## Investor deployment ########
resource "aws_api_gateway_deployment" "investor_deployment" {
  rest_api_id = aws_api_gateway_rest_api.investor_api.id
  stage_name  = "${var.env}"
  depends_on = [
     aws_api_gateway_integration.investor_api_root_OPTIONS_integration,
   ]
}

####### Investor key, Usage plan and stages ########
resource "aws_api_gateway_api_key" "investor_api" {
  name = "${title(lower(var.company_name))} ${var.env} Investor"
}

resource "aws_api_gateway_usage_plan" "investor_usage_plan" {
  name         = "${title(lower(var.company_name))} ${var.env} Investor UsagePlan"

/*
  quota_settings {
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
*/
  api_stages {
    api_id = aws_api_gateway_rest_api.investor_api.id
    stage  = aws_api_gateway_deployment.investor_deployment.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "investor_api" {
  key_id        = aws_api_gateway_api_key.investor_api.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.investor_usage_plan.id
}

