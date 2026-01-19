output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.this.name
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.this.id
}

output "ec2_sg_id" {
  description = "Security Group ID attached to ASG instances"
  value       = aws_security_group.ec2.id
}
