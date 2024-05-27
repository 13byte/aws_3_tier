resource "aws_security_group" "default" {
  name        = "default-${var.vpc_name}"
  description = "default sg for ${var.vpc_name}"
  vpc_id      = aws_vpc.default.id

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http any outbound"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "https any outbound"
  }

  tags = {
    Name = "default-sg-${var.vpc_name}"
  }
}
