output "asg_name" {
  description = "Auto Scaling Group name"
  value       = aws_autoscaling_group.this.name
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = aws_launch_template.this.id
}

output "key_pair_name" {
  description = "AWS Key Pair name created for SSH"
  value       = aws_key_pair.ec2_key.key_name
}

output "private_key_pem_path" {
  description = "Local path where the private key PEM is written"
  value       = local_file.ec2_private_key.filename
  sensitive   = true
}
