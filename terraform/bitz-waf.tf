
resource "aws_wafv2_web_acl" "cf-web-acl" {
  name        = "${title(lower(var.company_name))}_${var.env}_CloudFront_WebACL"
  description = "AWS managed rule."
  scope       = "CLOUDFRONT"
  provider    = aws.cloudfront

  default_action {
    allow {}
  }

  rule {
    name     = "${title(lower(var.company_name))}_${var.env}_CloudFront_AWSManagedRulesKnownBadInputsRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${title(lower(var.company_name))}_${var.env}_CloudFront_AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "${title(lower(var.company_name))}_${var.env}_CloudFront_AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        excluded_rule {
              name = "SizeRestrictions_BODY"
        }

        excluded_rule {
              name = "GenericRFI_BODY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${title(lower(var.company_name))}_${var.env}_CloudFront_AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${title(lower(var.company_name))}_${var.env}_CloudFront_WebACL"
    sampled_requests_enabled   = true
  }
}
####################################################################################################


resource "aws_wafv2_web_acl" "api-gw-web-acl" {
  name        = "${title(lower(var.company_name))}_${var.env}_API_Gateway_WebACL"
  description = "AWS managed rule."
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "${title(lower(var.company_name))}_${var.env}_API_Gateway_AWSManagedRulesKnownBadInputsRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${title(lower(var.company_name))}_${var.env}_API_Gateway_AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "${title(lower(var.company_name))}_${var.env}_API_Gateway_AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        excluded_rule {
              name = "SizeRestrictions_BODY"
        }

        excluded_rule {
              name = "GenericRFI_BODY"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${title(lower(var.company_name))}_${var.env}_API_Gateway_AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${title(lower(var.company_name))}_${var.env}_API_Gateway_WebACL"
    sampled_requests_enabled   = true
  }
}
