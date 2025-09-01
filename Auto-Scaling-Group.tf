resource "aws_launch_template" "launch_template" {
  name_prefix   = "${var.name_prefix}-launchTemplate"
  image_id      = var.ami_id
  instance_type = var.instance_type
    key_name      = aws_key_pair.deployer_key.key_name
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.private_sg.id]
    subnet_id                   = element(aws_subnet.private_subnet.*.id , 0)
  }

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-private-instance"
    }
  }

}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = aws_subnet.private_subnet.*.id
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
 target_group_arns = [aws_lb_target_group.app_tg.arn]
  
  health_check_type    = "EC2"
  health_check_grace_period = 300
  force_delete         = true

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-private-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
  
}