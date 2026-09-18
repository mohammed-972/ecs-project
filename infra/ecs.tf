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