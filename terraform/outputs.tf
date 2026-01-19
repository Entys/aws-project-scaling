output "vpc_id" {
  value = module.networking.vpc_id
}

output "alb_dns_name" {
  value = module.loadbalancer.alb_dns_name
}

output "target_group_arn" {
  value = module.loadbalancer.target_group_arn
}

output "asg_name" {
  value = module.autoscaling.asg_name
}

output "launch_template_id" {
  value = module.autoscaling.launch_template_id
}

output "asg_ec2_sg_id" {
  value = module.autoscaling.ec2_sg_id
}
