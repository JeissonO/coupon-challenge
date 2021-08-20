resource "aws_cognito_user_pool" "pool" {
  name = "${var.project}_${var.resource}"
  auto_verified_attributes = [
    "email",
  ]
  mfa_configuration          = "OFF"
  sms_authentication_message = "Your authentication code is {####}. "
  tags = {
    "Name"         = "${var.project}_${var.resource}"
    "Organization" = var.organization
    "Project"      = var.project
  }
  username_attributes = [
    "email",
  ]
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }
  admin_create_user_config {
    allow_admin_create_user_only = false
    invite_message_template {
      email_message = "Your username is {username} and temporary password is {####}. "
      email_subject = "Your temporary password"
      sms_message   = "Your username is {username} and temporary password is {####}. "
    }
  }
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }
  username_configuration {
    case_sensitive = false
  }
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_message        = "Your verification code is {####}. "
    email_subject        = "Your verification code"
    sms_message          = "Your verification code is {####}. "
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "${var.environment}-${var.project}-webapp"
  user_pool_id                         = aws_cognito_user_pool.pool.id
  generate_secret                      = true
  explicit_auth_flows                  = ["ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  prevent_user_existence_errors        = var.prevent_user_existence_errors
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  allowed_oauth_flows                  = var.allowed_oauth_flows
  supported_identity_providers         = var.supported_identity_providers
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls

  lifecycle {
    ignore_changes = [
      allowed_oauth_scopes, callback_urls, logout_urls, supported_identity_providers
    ]
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.environment}-${var.project}"
  user_pool_id = aws_cognito_user_pool.pool.id
}
