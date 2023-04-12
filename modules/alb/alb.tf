# Prerequisite: Create security group for this ALB
# This sg allows all external HTTP traffic to ALB
resource "aws_security_group" "lb_sg" {
  name = "${var.application_name}-lb-sg"
  vpc_id      = var.vpc_id
  description = "SG for application load balancer"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all HTTP 80 traffic to alb"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all HTTP 80 traffic to alb"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.application_name}-lb-sg"
  }
}


# Create a load balancer with a target group
resource "aws_lb" "main" {
  name               = "${var.application_name}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.public1_id, var.public2_id]

  security_groups = [
    aws_security_group.lb_sg.id
  ]

  tags = {
    Environment = "uat"
  }
}


# Create target group for ECS service
resource "aws_lb_target_group" "ecs_tg" {
  name             = "${var.application_name}-tg"
  port             = var.tg_port
  protocol         = "HTTP"
  target_type      = "ip"
  vpc_id           = var.vpc_id

  health_check {
    healthy_threshold   = 2
    interval            = 30
    path                = var.tg_healthcheck
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "tg-backend"
  }
}

# Associate ALB with target group
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    type             = "forward"
  }
}