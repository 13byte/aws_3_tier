# terraform import aws_route53_zone.main hosted_zone_id
resource "aws_route53_zone" "main" {
  name = var.domain_name

  lifecycle {
    prevent_destroy = false
  }
}

data "aws_route53_zone" "main" {
  zone_id = aws_route53_zone.main.zone_id
}

resource "aws_route53_zone" "internal" {
  name    = var.domain_name
  comment = "${var.vpc_name} - Managed by Terraform"

  vpc {
    vpc_id = aws_vpc.default.id
  }
}
