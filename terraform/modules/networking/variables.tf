# -------------------------
# AWS / VPC
# -------------------------

variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "eu-west-3" # Paris
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "AEH-VPC"
}

# -------------------------
# Public Subnet
# -------------------------

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_az" {
  description = "Availability Zone for the public subnet"
  type        = string
  default     = "eu-west-3a"
}

variable "public_subnet_name" {
  description = "Name tag for the public subnet"
  type        = string
  default     = "AEH-public-subnet"
}

# -------------------------
# Private Subnet
# -------------------------

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_subnet_az" {
  description = "Availability Zone for the private subnet"
  type        = string
  default     = "eu-west-3a"
  # Recommandé plus tard : eu-west-3b
}

variable "private_subnet_name" {
  description = "Name tag for the private subnet"
  type        = string
  default     = "AEH-private-subnet"
}

# -------------------------
# Security
# -------------------------

variable "allowed_ssh_cidr" {
  description = "CIDR autorisé pour SSH (ex: votre IP publique /32)"
  type        = string
  default = "0.0.0.0/0"
}

variable "monitoring_allowed_cidr" {
  description = "CIDR autorisé pour accéder au monitoring (Grafana/Prometheus)"
  type        = string
  default = "0.0.0.0/0"
}

variable "any" {
  description = "any"
  type        = string
  default = "0.0.0.0/0"
}

variable "name" {
  type        = string
  description = "Prefix/name for ALB resources"
  default     = "AEH-app"
}

#variable "vpc_id" {
#  type        = string
#  description = "VPC ID"
#}