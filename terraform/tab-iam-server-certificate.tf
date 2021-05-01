/*
This uploads the wildcard cert for use with AWS resources auch as Cloudfront and API gateway
*/

/*
resource "aws_iam_server_certificate" "bitz_cert" {
  name             = "bitz_cert"
  certificate_body = "${file(var.bitz_cert)}"
  private_key      = "${file(var.bitz_key}"
}

*/

/*
resource "aws_acm_certificate" "bitz_cert" {
  provider = "aws.acm"
  certificate_body = "${file(var.bitz_cert)}"
  certificate_chain = "${file(var.bitz_chain)}"
  private_key = "${file(var.bitz_key)}"
}
*/