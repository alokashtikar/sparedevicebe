
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

#######
# Setup bucket for webapp
resource "aws_s3_bucket" "webapp" {
  bucket = "${var.s3_webapp_bucket_name}"
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
    "Resource":["arn:aws:s3:::${var.s3_webapp_bucket_name}/*"]
  }
]
}
POLICY
}
