output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_1" {
  description = "ID of public subnet 1"
  value       = aws_subnet.public_1.id

}

output "public_subnet_2" {
  description = "ID of public subnet 2"
  value       = aws_subnet.public_2.id

}