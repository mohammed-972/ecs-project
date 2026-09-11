resource "aws_ecr_repository" "ecr" {
  name                 = "threat_composer"
  image_tag_mutability = "IMMUTABLE"

}