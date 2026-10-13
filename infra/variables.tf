variable "project_name" {
  type    = string
  default = "pomodoro-app"
}

variable "image_tag" {
  type    = string
  default = "v2"
}

variable "container_port" {
  type    = number
  default = 8080
}