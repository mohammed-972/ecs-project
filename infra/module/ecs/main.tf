resource "aws_cloudwatch_log_group" "ecs" {
  name = "ecs/${var.project_name}"

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
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.ecs_task_execution_role_arn
  container_definitions    = <<TASK_DEFINITION
  
[
  {
    "name": "main",
    "image": "296222413273.dkr.ecr.eu-west-2.amazonaws.com/threat_composer:c228b9d",
    "cpu": 256,
    "memory": 512,
    "essential": true,
  

    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort":       3000
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
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = [var.ecs_security_group_id]
    subnets          = [var.public_subnet_1, var.public_subnet_2]
  }

  load_balancer {
    container_name   = "main"
    container_port   = 3000
    target_group_arn = var.target_group_arn
  }

}