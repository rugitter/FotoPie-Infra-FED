# Create ESC Cluster
  resource "aws_ecs_cluster" "backend_cluster" {
    name = "backend-cluster"
  }

  resource "aws_cloudwatch_log_group" "fotopie_logs_group" {
    name = "/ecs/fotopie"

    tags = {
      Name = "fotopie-log-group"
   }
 }

  resource "aws_cloudwatch_log_stream" "fotopie_logs_stream" {
    name           = "fotopie-log-stream"
    log_group_name = aws_cloudwatch_log_group.fotopie_logs_group.name
  }

# create task definition
  resource "aws_ecs_task_definition" "fotopie" {
    family                   = "fotopie"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = "1024"
    memory                   = "2048"

# task_role & tast_execution_role already created
    # execution_role_arn = data.aws_iam_role.existing_ecs_execution_role.arn
    # task_role_arn = data.aws_iam_role.existing_ecs_task_role.arn

# when first create task_role & tast_execution_role
    execution_role_arn        = aws_iam_role.ecs_task_execution_role.arn
    # task_role_arn             = aws_iam_role.ecs_task_role.arn


    container_definitions = jsonencode([
       {
          "name": "fotopie",
          "image": "123436089261.dkr.ecr.ap-southeast-2.amazonaws.com/fotopie-fed:latest",
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
              "containerPort": 3000,
              "protocol": "tcp",
              "hostPort": 3000
            }
          ]
        }
      ])
    }


 # Create aws_ecs_service
  resource "aws_ecs_service" "fotopie_backend_service" {
    name                         = "fotopie-backend-service"
    cluster                      = aws_ecs_cluster.backend_cluster.id
    task_definition              = aws_ecs_task_definition.fotopie.arn
    desired_count                = 2
    scheduling_strategy          = "REPLICA"
    launch_type = "FARGATE"

    network_configuration {
      security_groups  = [aws_security_group.ecs_service_sg.id]
      subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
      assign_public_ip = true
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.main.arn
      container_name   = "fotopie"
      container_port   = 3000
     }

     depends_on = [aws_lb_listener.example]
}