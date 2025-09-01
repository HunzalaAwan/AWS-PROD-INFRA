output "lb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "bastion_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

data "aws_instances" "asg_instances" {
  filter {
    name   = "tag:Name"
    values = ["${var.name_prefix}-private-instance"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

output "asg_instance_private_ips" {
  value = data.aws_instances.asg_instances.private_ips
}

output "asg_instance_public_ips" {
  value = data.aws_instances.asg_instances.public_ips
}


