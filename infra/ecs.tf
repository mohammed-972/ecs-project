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
    "image": "296222413273.dkr.ecr.eu-west-2.amazonaws.com/threat_composer@sha256:fdd4a4097ebfe4beeb457f0e5f85cce3a47dbfe45d0d659664bf02f3aa70b738",
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
