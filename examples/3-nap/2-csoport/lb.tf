resource "aws_lb" "lb" {
  name               = "uni-lb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.lb.id
  ]

  subnets = aws_subnet.public.*.id
}

resource "aws_alb_listener" "hello" {
  load_balancer_arn = aws_lb.lb.arn

  port     = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "lb" {
  name     = "hello-target-group"
  port     = 5678
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_security_group" "lb" {
  name   = "lb"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb"
  }
}

resource "aws_vpc_security_group_egress_rule" "lb_to_ec2" {
  security_group_id = aws_security_group.lb.id
  referenced_security_group_id = aws_security_group.ec2.id
  from_port = 5678
  to_port = 5678
  ip_protocol = "tcp"
}
