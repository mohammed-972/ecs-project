variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "cidr block of VPC"
  default     = "10.0.0.0/16"
}

variable "az_1" {
  type = string
  default = "eu-west-2a"
}

variable "az_2" {
  type = string
  default = "eu-west-2b"
}

variable "all_traffic" {
  
}