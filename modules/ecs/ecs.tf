### Prerequisite 1: Create security group for ECS service
resource "aws_security_group" "ecs_service_sg" {
  name = "${var.application_name}-ecs-sg"
  vpc_id      = var.vpc_id
  description = "SG for ECS service"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.application_name}-ecs-sg"
   }
}

### Prerequisite 2: IAM ECS Task Execution Role
# 1. Create ecsTaskExecutionRole Role at first time 
# Move this role creation code to the iam module (not in use for now)
# Create IAM ECS Task Execution Role at first time 
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
 
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

# Attach the ECS task execution role policy to the ECS task execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
   role       = aws_iam_role.ecs_task_execution_role.name
}

# Query ecsTaskExecutionRole role if already existing
# data "aws_iam_role" "ecs_task_exec_role" {
#   name = "ecsTaskExecutionRole"
# }


### Create ESC Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.application_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "fotopie_logs_group" {
  name = "/ecs/${var.application_name}"

  tags = {
    Name = "fotopie-log-group"
  }
}

# Create task definition
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.application_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"

  # 2. When first run, create ecs tast_execution_role
  execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn

  # When tast_execution_role already created
  # execution_role_arn = data.aws_iam_role.ecs_task_exec_role.arn

  container_definitions = jsonencode([
    {
      "name": var.application_name,
      "image": "${var.ecr_uri}/${var.application_name}:latest",
      "cpu":    1024,
      "memory": 2048,
      "logConfiguration": {
              "logDriver": "awslogs",
              "options": {
                  "awslogs-region" : "ap-southeast-2",
                  "awslogs-group" : "/ecs/${var.application_name}",
                  "awslogs-stream-prefix" : "fotopie"
                }
            }
      "portMappings": [
        {
          "containerPort": var.tf_container_port,    # Change to 3000 for fed
          "protocol": "tcp",
          "hostPort": var.tf_container_port          # Change to 3000 for fed
        }
      ]
    }
  ])
}

# create auto-scaling target & policy
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "ScaleOutWhenCPUAbove60"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value      = 60
    scale_in_cooldown = 120
    scale_out_cooldown = 60
  }
}


# Create aws_ecs_service
resource "aws_ecs_service" "ecs_service" {
  name                         = "${var.application_name}-service"
  cluster                      = aws_ecs_cluster.main.id
  task_definition              = aws_ecs_task_definition.main.arn
  desired_count                = var.task_desired_count
  scheduling_strategy          = "REPLICA"
  launch_type = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_service_sg.id]
    subnets          = [var.private1_id]    #[var.private1_id, var.private2_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = var.application_name
    container_port   = var.tf_container_port        # 3000 for fed, 9090 for bed
    }

  #  depends_on = [aws_lb_listener.example]
}