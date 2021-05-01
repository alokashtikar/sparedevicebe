# create cognito user pool
resource "aws_cognito_user_pool" "investorPool" {
  name =  "${title(lower(var.company_name))}_${var.env}_Investors"

  admin_create_user_config {
    allow_admin_create_user_only = false
    #unused_account_validity_days = 7
    invite_message_template  {
      sms_message =  "your username is {username} and temporary password is {####}. "
      email_message =  "your username is {username} and temporary password is {####}. "
      email_subject =  "your temporary password for ${var.company_name_for_notifications}"
    }
  }

  auto_verified_attributes = ["email"]
  #alias_attributes = []

  username_attributes = ["email"]

  #device_configuration  {
    #challenge_required_on_new_device =  false
    #device_only_remembered_on_user_prompt =  true
  #}

  /* This conflicts with verification_message_template below
  email_verification_message =  "Your verification code is {####}."
  email_verification_subject =  "${var.company_name} registration"
  */

  password_policy  {
    minimum_length = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers = true
    require_symbols = true
  }

  verification_message_template  {
    email_message_by_link = "Thank you for registering with Bitz. To complete the registration process, please verify your email by clicking the following link: {##Click Here##}"
    email_subject = "${var.company_name_for_notifications} registration"
    email_message = "Thank you for registering with Bitz. To complete the registration process, please verify your email by entering the following code in the App: {####}"
    default_email_option =  "CONFIRM_WITH_CODE"
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
/*
  tags  {
    key_name =  ""
  }
*/
  schema {
    name =  "email"
    attribute_data_type = "String"
    required =  true
    developer_only_attribute = false
    mutable = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }
  schema {
    name =  "phone_number"
    attribute_data_type = "String"
    required =  true
    developer_only_attribute = false
    mutable = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  user_pool_add_ons  {
    advanced_security_mode =  "AUDIT"
  }
}


resource "aws_cognito_user_pool_client" "investorClient" {
  name =  lower("${var.company_name}-Investors")
  user_pool_id = "${aws_cognito_user_pool.investorPool.id}"
  generate_secret = false
  supported_identity_providers = ["COGNITO"]
  refresh_token_validity = 30
  #explicit_auth_flows = [
      #"USER_PASSWORD_AUTH"
  #]
  callback_urls = [
      "${var.cognito_client_investors_callback}"
  ]
  logout_urls = [
      "${var.cognito_client_investors_signout}"
  ]
  allowed_oauth_flows = [
      "implicit"
  ]
  allowed_oauth_scopes = [
      "openid", "email"
  ]
  allowed_oauth_flows_user_pool_client= true
}


resource "aws_cognito_user_pool_domain" "investorDomain" {
  domain       = "${var.cognito_user_pool_investors_domain}"
  user_pool_id = "${aws_cognito_user_pool.investorPool.id}"
}

output "cognito_auth_url_investors" {
  value = "https://${var.cognito_user_pool_investors_domain}.auth.${var.aws_region}.amazoncognito.com/login?response_type=token&client_id=${aws_cognito_user_pool_client.investorClient.id}&redirect_uri=http://localhost"
}
