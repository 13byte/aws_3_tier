resource "aws_ec2_instance_connect_endpoint" "default" {
  subnet_id          = aws_subnet.private_was[0].id
  security_group_ids = [aws_security_group.eic.id]

  tags = {
    Name = "ec2-instance-endpoint-${var.vpc_name}"
  }
}
