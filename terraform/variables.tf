# Région AWS
variable "aws_region" {
  description = "Paris"
  type        = string
  default     = "eu-west-3"
}

# CIDR du VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# CIDR du subnet public
variable "public subnet cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Availability Zone du subnet
variable "public subnet az" {
  description = "Availability Zone for the public subnet"
  type        = string
  default     = "eu-west-3a"
}

# Nom du VPC
variable "vpc_name" {
  description = "TEST-VPC
  type        = string
  default     = "my-vpc"
}

# Nom du subnet public
variable "public_subnet_name" {
  description = "subnet-public"
  type        = string
  default     = "my-public-subnet"
}
