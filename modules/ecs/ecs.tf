# Prerequisite: Create security group for ECS service
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

# Prerequisite 2:
# Create IAM ECS Task Execution Role at first time 
# resource "aws_iam_role" "ecs_task_execution_role" {
#   name = "ecsTaskExecutionRole"
 
#   assume_role_policy = <<EOF
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Action": "sts:AssumeRole",
#         "Principal": {
#           "Service": "ecs-tasks.amazonaws.com"
#         },
#         "Effect": "Allow",
#         "Sid": ""
#       }
#     ]
#   }
#   EOF
# }

# # Attach the ECS task execution role policy to the ECS task execution role
# resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
#    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
#    role       = aws_iam_role.ecs_task_execution_role.name
# }

# Query Data IAM role - ecs_task_execution_role
data "aws_iam_role" "ecs_task_exec_role" {
  name = "ecsTaskExecutionRole"
}


# Create ESC Cluster
  resource "aws_ecs_cluster" "main" {
    name = "${var.application_name}-cluster"
  }

  resource "aws_cloudwatch_log_group" "fotopie_logs_group" {
    name = "/ecs/fotopie"

    tags = {
      Name = "fotopie-log-group"
   }
 }

  resource "aws_cloudwatch_log_stream" "fotopie_logs_stream" {
    name           = "${var.application_name}-log-stream"
    log_group_name = aws_cloudwatch_log_group.fotopie_logs_group.name
  }

# create task definition
  resource "aws_ecs_task_definition" "main" {
    family                   = "fotopie"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "1024"
    memory                   = "2048"

# When first run, create ecs tast_execution_role
    # execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn
    # task_role_arn             = aws_iam_role.ecs_task_role.arn

# When tast_execution_role already created
    execution_role_arn = data.aws_iam_role.ecs_task_exec_role.arn
    # task_role_arn = data.aws_iam_role.existing_ecs_task_role.arn

    container_definitions = jsonencode([
        {
          "name": "fotopie-bed",
          "image": "236158853494.dkr.ecr.ap-southeast-2.amazonaws.com/fotopie-bed:latest",
          "cpu":    128,
          "memory": 256,
          "logConfiguration": {
                  "logDriver": "awslogs",
                  "options": {
                      "awslogs-region" : "ap-southeast-2",
                      "awslogs-group" : "/ecs/fotopie",
                      "awslogs-stream-prefix" : "ecs"
                   }
                }
          "portMappings": [
            {
              "containerPort": 9090,    # Change to 3000 for fed
              "protocol": "tcp",
              "hostPort": 9090          # Change to 3000 for fed
            }
          ]
        }
      ])
    }


#  # Create aws_ecs_service
#   resource "aws_ecs_service" "ecs_service" {
#     name                         = "fotopie-backend-service"
#     cluster                      = aws_ecs_cluster.main.id
#     task_definition              = aws_ecs_task_definition.main.arn
#     desired_count                = var.task_desired_count
#     scheduling_strategy          = "REPLICA"
#     launch_type = "FARGATE"

#     network_configuration {
#       security_groups  = [aws_security_group.ecs_service_sg.id]
#       subnets          = [var.private1_id]    #[var.private1_id, var.private2_id]
#       assign_public_ip = true
#     }

#     load_balancer {
#       target_group_arn = var.alb_tg_arn
#       container_name   = "fotopie-bed"
#       container_port   = 9090           # Need to change to 3000 for fed
#      }

#     #  depends_on = [aws_lb_listener.example]
# }