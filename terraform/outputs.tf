output "vpc_id" {
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  value       = module.networking.public_subnet_ids
}

output "monitoring_sg_id" {
  value       = module.networking.monitoring_sg_id
}

output "alb_sg_id" {
  value       = module.networking.alb_sg_id
}

output "ec2_sg_id" {
  value       = module.networking.ec2_sg_id
}

output "alb_dns_name" {
  value       = module.loadbalancer.alb_dns_name
}

output "asg_name" {
  value       = try(module.autoscaling.asg_name, "")
}