data "aws_route53_zone" "private" {
  name         = "lan.lan."
  private_zone = true
}