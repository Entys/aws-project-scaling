variable "app_version" {
  type        = string
}

variable "aws_region" {
  type        = string
}

variable "instance_type" {
  type        = string
  description = "EC2 instance"
  default     = "t2.micro"
}

variable "base_ami_owner" {
  type        = string
  description = "AWS ID debian"
  default     = "136693071363"
}

variable "base_ami_filter" {
  type        = string
  default     = "debian-12-amd64-*"
}

variable "ssh_username" {
  type        = string
  default     = "admin"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subne"
}

variable "security_group_ids" {
  type        = list(string)
  description = "SG IDs"
}