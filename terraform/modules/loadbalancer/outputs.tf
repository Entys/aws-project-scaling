output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_sg_id" {
  value = var.alb_sg_id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}