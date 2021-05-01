output "api_key_value" {
  description = "api key value"
  value       = aws_api_gateway_api_key.api.value
}

output "waf_arn" {
  description = "web_acl arn"
  value = aws_wafv2_web_acl.api-gw-web-acl.arn
}
