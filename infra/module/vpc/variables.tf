variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "cidr block of VPC"
  default     = "10.0.0.0/16"
}