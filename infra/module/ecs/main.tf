resource "aws_cloudwatch_log_group" "ecs" {
  name = "ecs/${var.project_name}"

  tags = {
    purpose = "container-logs"
  }

}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "td" {
  family                   = "${var.project_name}-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.ecs_task_execution_role_arn
  container_definitions    = <<TASK_DEFINITION
  
[
  {
    "name": "main",
    "image": "${var.image_uri}",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "essential": true,
  

    "portMappings": [
      {
        "containerPort": ${var.container_port}
      }
    
    ],

    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.ecs.name}",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"


    }
  }
}
]
TASK_DEFINITION

}


resource "aws_ecs_service" "service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.td.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = false
    security_groups  = [var.ecs_security_group_id]
    subnets          = [var.private_subnet_1, var.private_subnet_2]
  }

  load_balancer {
    container_name   = "main"
    container_port   = var.container_port
    target_group_arn = var.target_group_arn
  }

}