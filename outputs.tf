# Region
output "aws_region" {
  description = "Region of VPC"
  value       = var.aws_region
}

output "region_namespace" {
  description = "Region name without '-'"
  value       = replace(var.aws_region, "-", "")
}

# Availability_zones
output "availability_zones" {
  description = "Availability zone list of VPC"
  value       = var.availability_zones
}

output "short_azs" {
  description = "Short Availability zone list of VPC"
  value       = var.short_azs
}

# VPC
output "vpc_name" {
  description = "The name of the VPC which is also the environment name"
  value       = var.vpc_name
}

output "vpc_id" {
  description = "VPC ID of newly created VPC"
  value       = aws_vpc.default.id
}

output "cidr_block" {
  description = "CIDR block of VPC"
  value       = aws_vpc.default.cidr_block
}

output "cidr_numeral" {
  description = "number that specifies the vpc range (B class)"
  value       = var.cidr_numeral
}

# Public subnets
output "public_subnets" {
  description = "List of public subnet ID in VPC"
  value       = aws_subnet.public.*.id
}

# Prviate WAS subnets
output "private_subnets" {
  description = "List of WAS private subnet ID in VPC"
  value       = aws_subnet.private_was.*.id
}

# Private Database Subnets
output "db_private_subnets" {
  description = "List of DB private subnet ID in VPC"
  value       = aws_subnet.private_db.*.id
}

# Route53
output "route53_main_zone_id" {
  description = "Public Zone ID for VPC"
  value       = aws_route53_zone.main.zone_id
}

output "route53_main_domain" {
  description = "Public Domain Name for VPC"
  value       = aws_route53_zone.main.name
}

output "route53_internal_zone_id" {
  description = "Internal Zone ID for VPC"
  value       = aws_route53_zone.internal.zone_id
}

output "route53_internal_domain" {
  description = "Internal Domain Name for VPC"
  value       = aws_route53_zone.internal.name
}

#S3
output "origin_s3_id" {
  description = "cloudfront origin s3 id"
  value       = aws_s3_bucket.origin_s3.id
}

output "origin_s3_zone_id" {
  description = "cloudfront origin s3 zone id"
  value       = aws_s3_bucket.origin_s3.hosted_zone_id
}

# Security Group
output "aws_security_group_default_id" {
  description = "ID of default security group"
  value       = aws_security_group.default.id
}
