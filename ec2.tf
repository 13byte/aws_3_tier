# resource "aws_instance" "was" {
#   count             = length(var.availability_zones)
#   ami               = "ami-0b8414ae0d8d8b4cc" # Amazon Linux 2023 AMI
#   instance_type     = "t2.micro"
#   availability_zone = element(var.availability_zones, count.index)
#   subnet_id         = element(aws_subnet.private_was.*.id, count.index)

#   root_block_device {
#     delete_on_termination = true
#     volume_size           = 10
#     volume_type           = "gp3"
#   }

#   tags = {
#     Name = "was-${var.vpc_name}-${element(var.short_azs, count.index)}"
#   }
# }

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

  egress {
    to_port     = 8080
    from_port   = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http outbound"
  }

  tags = {
    Name = "ec2-${var.vpc_name}"
  }
}
