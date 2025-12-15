output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "public_subnet_cidr" {
  description = "The CIDR block of the public subnet"
  value       = aws_subnet.public_subnet.cidr_block
}

output "public_subnet_az" {
  description = "The Availability Zone of the public subnet"
  value       = aws_subnet.public_subnet.availability_zone
}

output "alb_sg_id" { value = aws_security_group.alb_sg.id }
output "ec2_sg_id" { value = aws_security_group.ec2_sg.id }
output "monitoring_sg_id" { value = aws_security_group.monitoring_sg.id }
