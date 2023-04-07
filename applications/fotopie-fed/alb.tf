# Create security group for load balancer and ECS service
resource "aws_security_group" "lb_sg" {
  name = "lb_sg"
  vpc_id      = aws_vpc.main.id
  description = "sg for ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "lb_sg"
  }
}

# Create security group for ECS service
resource "aws_security_group" "ecs_service_sg" {
  name = "ecs_service_sg"
  vpc_id      = aws_vpc.main.id
  description = "sg for ECS service"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ecs_service_sg"
   }
}

# Create a load balancer with a target group
resource "aws_lb" "main" {
  name               = "ALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  security_groups = [
    aws_security_group.lb_sg.id
  ]

  tags = {
    Name = "ALB"
  }
}


# Create target group for ECS service
resource "aws_lb_target_group" "main" {
  name             = "tg-backend"
  port             = 80
  protocol         = "HTTP"
  target_type      = "ip"
  vpc_id           = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    interval            = 30
    path                = "/api/user"
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
resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.main.arn
    type             = "forward"
  }
}