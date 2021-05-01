#common variables
/*vars {

*/



#Create S3 bucket for PII
resource "aws_s3_bucket" "privateBucket" {
  bucket = "${var.s3_private_bucket_name}"
  acl    = "private"

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  tags = {
    Name        = "${var.s3_private_bucket_name}"
    Environment = "${var.env_name}"
  }
}

#Create S3 bucket for Public assets
resource "aws_s3_bucket" "publicBucket" {
  bucket = "${var.s3_public_bucket_name}"
  acl    = "public-read"

  versioning {
    enabled = true
  }

   cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  tags = {
    Name        = "${var.s3_public_bucket_name}"
    Environment = "${var.env_name}"
  }
}

#set policy to forbid all public access to pii
resource "aws_s3_bucket_public_access_block" "privateBucket" {
  bucket = "${aws_s3_bucket.privateBucket.id}"

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

#######
# Setup bucket for backoffice
resource "aws_s3_bucket" "backoffice" {
  bucket = "${var.s3_bo_bucket_name}"
  acl    = "public-read"
  #policy = "${file("policy.json")}"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  versioning {
    enabled = true
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST", "GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

     policy = <<POLICY
{
"Version":"2012-10-17",
"Statement":[
  {
    "Sid":"AddPerm",
    "Effect":"Allow",
    "Principal": "*",
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::${var.s3_bo_bucket_name}/*"]
  }
]
}
POLICY
}
