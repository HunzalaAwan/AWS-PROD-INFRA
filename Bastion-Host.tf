resource "aws_instance" "bastion_host" {
  ami           = var.bastion_ami_id
  instance_type = var.bastion_instance_type
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  key_name      = aws_key_pair.deployer_key.key_name

  vpc_security_group_ids = [aws_security_group.public_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "${var.name_prefix}-bastion-host"
    Tier = "bastion"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update 
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx              
              EOF

  lifecycle {
    create_before_destroy = true
  }
  
}