# event_source_arn = "${aws_dynamodb_table.TABLE_NAME_HERE.stream_arn}"
# how to add trigger is above


#########
# This section caters for Lambda
#

####################
# Create lambda iam role and trust relationship
resource "aws_iam_role" "lambda-role" {
  name = "${var.env_name}-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "edgelambda.amazonaws.com",
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


####################
# Create lambda iam policy from file
resource "aws_iam_policy" "lambda-policy" {
  name = "${var.env_name}-lambda-policy"
  policy = file(var.iam_lambda_policy_file)
}


####################
# attach lambda iam policy to role
resource "aws_iam_role_policy_attachment" "lambda-attach" {
  role       = "${aws_iam_role.lambda-role.name}"
  policy_arn = "${aws_iam_policy.lambda-policy.arn}"
}

###########################################

/*
#########
# This section caters for ocgnito identity pool
#

####################
# Create identitypool  iam role and trust relationship
resource "aws_iam_role" "identitypool-backoffice-authenticated-role" {
  name = "${title(lower(var.company_name))}_${var.env}_BackOffice_Authenticated"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.backoffice.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

####################
# Create identitypool  iam role and trust relationship
resource "aws_iam_role" "identitypool-backoffice-unauthenticated-role" {
  name = "${title(lower(var.company_name))}_${var.env}_BackOffice_UnAuthenticated"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.backoffice.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "unauthenticated"
        }
      }
    }
  ]
}
EOF
}


####################
# Create authentiticated identity pool iam policy from file
resource "aws_iam_policy" "identitypool-backoffice-authenticated-policy" {
  name = "${var.env_name}-identitypool-backoffice-authenticated-policy"
  policy = file(var.iam_identity_backoffice_authenticated_policy_file)
}

####################
# Create unauthenticated identity pool iam policy from file
resource "aws_iam_policy" "identitypool-backoffice-unauthenticated-policy" {
  name = "${var.env_name}-identitypool-backoffice-unauthenticated-policy"
  policy = file(var.iam_identity_backoffice_unauthenticated_policy_file)
}

####################
# attach backoffice authenticated identity pool iam policy to role
resource "aws_iam_role_policy_attachment" "backoffice-authenticated-identitypool-attach" {
  role       = "${aws_iam_role.identitypool-backoffice-authenticated-role.name}"
  policy_arn = "${aws_iam_policy.identitypool-backoffice-authenticated-policy.arn}"
}
####################
# attach backoffice unauthenticated identity pool iam policy to role
resource "aws_iam_role_policy_attachment" "backoffice-unauthenticated-identitypool-attach" {
  role       = "${aws_iam_role.identitypool-backoffice-unauthenticated-role.name}"
  policy_arn = "${aws_iam_policy.identitypool-backoffice-unauthenticated-policy.arn}"
}
*/