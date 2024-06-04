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
