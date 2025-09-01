/** module "lb" {
  source           = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"
  name             = "${var.name_prefix}-alb"
  load_balancer_type = "application"
  subnets          = aws_subnet.public_subnet[*].id
  security_groups = [aws_security_group.public_sg.id]
  
  enable_deletion_protection = false
  internal                   = false

  tags = {
    Environment = "prod"
    Name        = "${var.name_prefix}-alb"
  }
  target_groups = {
    default = {
      name_prefix      = "TG"
      port             = 80
      protocol         = "HTTP"
      target_type      = "instance"
      vpc_id           = aws_vpc.Prd_vpc.id
      health_check = {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
        matcher             = "200-399"
      }
      target_group_arns = [aws_lb_target_group.tg.arn]

      listeners = {
       http = {
       port     = 80
       protocol = "HTTP"
       forward  = {
       target_group_key = "default"
      }
    }
  }
    }

  }
  
}**/

resource "aws_lb" "alb" {
  name               = "${var.name_prefix}-alb"
  internal          = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.public_sg.id]
  subnets           = aws_subnet.public_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Environment = "prod"
    Name        = "${var.name_prefix}-alb"
  }
}
resource "aws_lb_target_group" "app_tg" {
  name_prefix = "TG"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.Prd_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Environment = "prod"
    Name        = "${var.name_prefix}-tg"
  }
}
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}