resource "aws_lb" "alb" {
  name               = var.alb_name
  internal = false
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups = var.sgroup

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
  target_type = "instance"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
