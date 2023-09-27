resource "aws_lb" "hello" {
  name               = "hello"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = aws_subnet.public.*.id
}

resource "aws_alb_listener" "hello" {
  load_balancer_arn = aws_lb.hello.arn

  port     = "80"
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.hello.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "hello" {
  name     = "hello-target-group"
  port     = 5678
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_security_group" "alb" {
  name   = "alb"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb"
  }
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ec2" {
  security_group_id            = aws_security_group.alb.id
  from_port                    = 5678
  to_port                      = 5678
  referenced_security_group_id = aws_security_group.ec2.id
  ip_protocol                  = "-1"
}