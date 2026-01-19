variable "name" {
  type        = string
  description = "Prefix/name for ALB resources"
  default     = "AEH-app"
}

variable "alb_sg_id" {
  type        = string
  description = "Security Group ID for the ALB"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs"
  default = [ "eu-west-3a,eu-west-3b" ]
}

variable "target_port" {
  type        = number
  description = "Target group port"
  default     = 80
}

variable "health_check_path" {
  type        = string
  description = "Health check path"
  default     = "/"
}


