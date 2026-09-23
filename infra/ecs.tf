resource "aws_cloudwatch_log_group" "ecs" {
  name = "ecs/threat-composer"

}

resource "aws_ecs_cluster" "cluster" {
  name = "ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "td" {
  family                   = "threat-composer-td"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
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
        "awslogs-group": "ecs/threat-composer",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"


    }
  }
}
]
TASK_DEFINITION

}


resource "aws_ecs_service" "service" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.td.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs.id]
    subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  }

  load_balancer {
    container_name   = "main"
    container_port   = 3000
    target_group_arn = aws_lb_target_group.tg.arn
  }

}