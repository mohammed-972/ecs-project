terraform {
  backend "s3" {
    bucket = "mo-s3-bucket-terraform"
    key    = "ecs-project/terraform.tfstate"
    region = "eu-west-2"
    use_lockfile = true
  }
} 
