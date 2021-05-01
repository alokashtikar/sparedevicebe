output "api_key_value_binary" {
  description = "api key value for Binary"
  value       = aws_api_gateway_api_key.binary_api.value
}

/* output "api_key_value_backoffice" {
  description = "api key value for BackOffice"
  value       = aws_api_gateway_api_key.backoffice_api.value
}

output "api_key_value_investor" {
  description = "api key value for Investor"
  value       = aws_api_gateway_api_key.investor_api.value
}
*/

output "waf_arn" {
  description = "web_acl arn"
  value = aws_wafv2_web_acl.api-gw-web-acl.arn
}
