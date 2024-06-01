# terraform import aws_route53_zone.main hosted_zone_id
data "aws_route53_zone" "main_data" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_route53_zone" "internal" {
  name    = var.domain_name
  comment = "${var.vpc_name} - Managed by Terraform"

  vpc {
    vpc_id = aws_vpc.default.id
  }
}
