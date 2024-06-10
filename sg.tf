resource "aws_security_group" "ec2" {
  name        = "ec2-${var.vpc_name}"
  description = "ec2 sg for ${var.vpc_name}"
  vpc_id      = aws_vpc.default.id

  ingress {
    to_port         = 8080
    from_port       = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
    description     = "http alb inbound"
  }

  ingress {
    to_port         = 22
    from_port       = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.eic.id]
    description     = "ssh ec2 instance connect endpoint inbound"
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http outbound"
  }

  tags = {
    Name = "ec2-${var.vpc_name}"
  }
}

resource "aws_security_group" "alb" {
  name        = "alb-${var.vpc_name}"
  description = "alb sg for ${var.vpc_name}"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    prefix_list_ids = ["pl-22a6434b"]
    description     = "https cloudfront inbound"
  }

  egress {
    to_port     = 0
    from_port   = 0
    protocol    = "-1"
    description = "http cloudfront outbound"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-${var.vpc_name}"
  }
}

resource "aws_security_group" "elasticache-redis" {
  name        = "elasticache-redis-${var.vpc_name}"
  description = "elasticache redis sg for ${var.vpc_name}"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
    description     = "ec2 inbound"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound"
  }

  tags = {
    Name = "elasticache-redis-sg-${var.vpc_name}"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-${var.vpc_name}"
  description = "rds sg for ${var.vpc_name}"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2.id]
    description     = "ec2 inbound"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound"
  }

  tags = {
    Name = "rds-sg-${var.vpc_name}"
  }
}

resource "aws_security_group" "eic" {
  name        = "eic-${var.vpc_name}"
  description = "ec2 instance connect endpoint for ${var.vpc_name}"
  vpc_id      = aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eic-${var.vpc_name}"
  }
}
