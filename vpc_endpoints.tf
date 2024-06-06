resource "aws_ec2_instance_connect_endpoint" "default" {
  subnet_id          = aws_subnet.private_was[0].id
  security_group_ids = [aws_security_group.eic.id]

  tags = {
    Name = "ec2-instance-endpoint-${var.vpc_name}"
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
