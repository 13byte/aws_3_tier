variable "aws_region" {
  default = "ap-northeast-2"
}

variable "vpc_name" {
  description = "The VPC name"
}

variable "cidr_numeral" {
  description = "The VPC CIDR numeral (10.x.0.0/16)"
}

variable "availability_zones" {
  type        = list(string)
  description = "A comma-delimited list of availability zones for the VPC."
}

variable "short_azs" {
  type        = list(string)
  description = "A comma-delimited list of availability zones for the VPC."
}

variable "cidr_numeral_public" {
  default = {
    "0" = "0"
    "1" = "16"
    "2" = "32"
  }
}

variable "cidr_numeral_private_was" {
  default = {
    "0" = "80"
    "1" = "96"
    "2" = "112"
  }
}

variable "cidr_numeral_private_db" {
  default = {
    "0" = "160"
    "1" = "176"
    "2" = "192"
  }
}

variable "domain_name" {
  description = "regional domain name"
}

variable "internal_domain_name" {
  description = "regional internal domain name"
}

variable "aws_linux_image_id" {
  description = "AMI ID for instance"
  type        = string
  default     = "ami-0b8414ae0d8d8b4cc"
}

variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
  default     = "t2.mirco"
}

variable "min_size" {
  description = "Auto Scaling min size"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Auto Scaling max size"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Auto Scaling desired capacity"
  type        = number
  default     = 1
}
