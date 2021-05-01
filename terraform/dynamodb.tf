
####################
# listing
resource "aws_dynamodb_table" "ListingTable" {
  name           = "${title(lower(var.company_name))}_${var.env}_ListingTable"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  point_in_time_recovery {
    enabled = "${var.dynamodb_point_in_time_recovery}"
  }

  billing_mode = "PAY_PER_REQUEST"
}
