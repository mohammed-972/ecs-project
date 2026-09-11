terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.63.0"
    }
  }
}

provider "aws" {
  # Configuration options
}


terraform {
  backend "s3" {
    bucket = "mo-s3-bucket-terraform"
    key    = "ecs-project"
    region = "eu-west-2"
  }
}



