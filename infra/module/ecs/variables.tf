variable "project_name" {
  type = string
}

variable "ecs_security_group_id" {
  type = string
}

variable "public_subnet_1" {
  type = string
}

variable "public_subnet_2" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "image_uri" {
  type = string
}