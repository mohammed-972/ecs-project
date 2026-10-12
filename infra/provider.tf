terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
  # Configuration options

  default_tags {
    tags = {
      project_name = var.project_name
      environment = "prod" 
      managed = "terraform" 
      owner = "mohammed"
   }
 }
}