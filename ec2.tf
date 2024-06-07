resource "aws_launch_template" "was" {
  name                                 = "ec2-template-${var.vpc_name}"
  description                          = "launch template for was"
  instance_type                        = "t2.micro"
  image_id                             = var.aws_linux_image_id
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = [aws_security_group.ec2.id]

  credit_specification {
    cpu_credits = "standard"
  }

  user_data = filebase64("./settings.sh")

  tags = {
    Name = "ec2-template-${var.vpc_name}"
  }
}

resource "aws_autoscaling_group" "default" {
  name             = "autoscaling-group-${var.vpc_name}"
  min_size         = var.min_size
  max_size         = var.min_size
  desired_capacity = var.desired_capacity

  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.was_tg.arn]

  force_delete        = true
  vpc_zone_identifier = [for subnet in aws_subnet.private_was.* : subnet.id]

  launch_template {
    id      = aws_launch_template.was.id
    version = aws_launch_template.was.latest_version
  }

  depends_on = [aws_db_instance.default, aws_route53_record.rds]
}
