variable "project_name" {
  type        = string
  description = "name of project"
  default     = "threat-composer"
}

variable "vpc_cidr" {
  type        = string
  description = "cidr block of VPC"
  default     = "10.0.0.0/16"
}