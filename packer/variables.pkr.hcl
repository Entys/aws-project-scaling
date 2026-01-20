variable "app_version" {
  type        = string
  description = "App version"
}

variable "aws_region" {
  type        = string
  description = "AWS region where the AMI is"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "base_ami_owner" {
  type        = string
  description = "AWS ID"
  default     = "136693071363"
}

variable "base_ami_filter" {
  type        = string
  description = "Filter AMI"
  default     = "debian-12-amd64-*"
}

variable "ssh_username" {
  type        = string
  description = "SSH username AMI"
  default     = "admin"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet where AMI"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs"
}