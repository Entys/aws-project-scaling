output "monitoring_instance_id" {
  value = aws_instance.monitoring.id
}

output "monitoring_public_ip" {
  value = aws_instance.monitoring.public_ip
}

output "monitoring_private_key_path" {
  value = local_file.monitoring_private_key.filename
}
