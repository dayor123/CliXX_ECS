#Load Balancer in the Public Subnet 
resource "aws_lb" "alb" {
  name               = "clixx-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pub-instance-sg.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]

  enable_deletion_protection = false

  tags = {
    Environment = "Development"
  }
}

resource "aws_lb_target_group" "alb-tg" {
  name     = "clixx-app-tg-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev-vpc.id

  health_check {
    port     = 80
    protocol = "HTTP"
  }

}

resource "aws_lb_listener" "alb-listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}