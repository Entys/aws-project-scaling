variable "name" {
  description = "Prefix/name for resources"
  type        = string
  default     = "app"
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

variable "subnet_ids" {
  description = "Subnets where ASG launches instances. Use PUBLIC subnets to get public IPs."
  type        = list(string)
}

variable "ec2_sg_id" {
  description = "Security group ID attached to instances (from networking module)"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN to register instances"
  type        = string
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

# Scaling thresholds
variable "cpu_scale_out_threshold" {
  description = "CPU % threshold to scale out"
  type        = number
  default     = 50
}

variable "cpu_scale_in_threshold" {
  description = "CPU % threshold to scale in"
  type        = number
  default     = 30
}

variable "alarm_period_seconds" {
  description = "CloudWatch alarm period (seconds)"
  type        = number
  default     = 30
}

variable "alarm_evaluation_periods" {
  description = "Number of periods to evaluate"
  type        = number
  default     = 2
}
