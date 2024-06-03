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

# acm validation
resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.main.domain_validation_options)[0].resource_record_type
  ttl             = 60
  zone_id         = data.aws_route53_zone.main_data.zone_id
}

# cloudfront alias1 (var.domain_name)
resource "aws_route53_record" "cloudfront_alias1" {
  name    = var.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.main_data.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# cloudfront alias2 (www.var.domain_name)
resource "aws_route53_record" "cloudfront_alias2" {
  name    = "www.${var.domain_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.main_data.zone_id

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
