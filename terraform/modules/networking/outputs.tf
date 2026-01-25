output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private : s.id]
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "monitoring_sg_id" {
  value = aws_security_group.monitoring_sg.id
}

output "ec2_sg_id" {
  description = "Security Group ID for EC2 instances"
  value       = aws_security_group.ec2_sg.id
}

output "monitoring_sg_ids" {
  description = "Security group IDs for monitoring"
  value       = [aws_security_group.monitoring_sg.id, aws_security_group.alb_sg.id]
}
