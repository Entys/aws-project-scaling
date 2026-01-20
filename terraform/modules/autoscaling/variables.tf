variable "name" {
  description = "Prefix/name for resources"
  type        = string
  default     = "app"
}

variable "vpc_id" {
  description = "VPC ID (kept for compatibility, not used directly here)"
  type        = string
  default     = ""
}

variable "ec2_sg_id" {
  description = "Security Group ID attached to ASG instances (from networking)"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where ASG launches instances"
  type        = list(string)
}

variable "target_group_arn" {
  description = "Target Group ARN to register instances"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "min_size" {
  description = "Minimum instances"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum instances"
  type        = number
  default     = 5
}

variable "user_data" {
  description = "User data script (optional)"
  type        = string
  default     = ""
}
