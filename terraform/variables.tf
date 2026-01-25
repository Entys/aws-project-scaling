variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "name" {
  type    = string
  default = "AEH-app"
}

# --- network ---
variable "vpc_cidr" { type = string }
variable "vpc_name" { type = string }

variable "public_subnet_cidrs" { type = list(string) }
variable "public_subnet_azs" { type = list(string) }
variable "public_subnet_names" {
  type    = list(string)
  default = ["AEH-public-a", "AEH-public-b"]
}

variable "private_subnet_cidrs" { type = list(string) }
variable "private_subnet_azs" { type = list(string) }
variable "private_subnet_names" {
  type    = list(string)
  default = ["AEH-private-a", "AEH-private-b"]
}

# --- Security ---
variable "monitoring_allowed_cidr" { type = string }
variable "allowed_ssh_cidr" { type = string }

# --- ALB ---
variable "target_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

# --- AS_G ---
variable "ami_id" {
  description = "AMI ID for EC2 instances (will be set by Packer)"
  type        = string
  default     = "ami-placeholder"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "min_size" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 5
}

variable "user_data" {
  type    = string
  default = ""
}
variable "ec2_key_name" {
  type    = string
  default = null
}

variable "key_name" {
  description = "SSH key name for EC2 instances"
  type        = string
  default     = "AEH-app-key"
}

variable "scale_up_threshold" {
  description = "CPU threshold to scale up"
  type        = number
  default     = 70
}

variable "scale_down_threshold" {
  description = "CPU threshold to scale down"
  type        = number
  default     = 30
}
