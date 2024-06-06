resource "aws_vpc_endpoint" "ec2_connect" {
  vpc_id             = aws_vpc.default.id
  service_name       = "com.amazonaws.${var.aws_region}.ec2-instance-connect"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.private_was[0].id]
  security_group_ids = [aws_security_group.eic.id]

  private_dns_enabled = true

  tags = {
    Name = "ec2-connect-${var.vpc_name}"
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
