variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "name" {
  type    = string
  default = "AEH-app"
}

# --- Réseau ---
variable "vpc_cidr" { type = string }
variable "vpc_name" { type = string }

variable "public_subnet_cidrs" { type = list(string) }
variable "public_subnet_azs"   { type = list(string) }
variable "public_subnet_names" {
  type    = list(string)
  default = ["AEH-public-a", "AEH-public-b"]
}

variable "private_subnet_cidrs" { type = list(string) }
variable "private_subnet_azs"   { type = list(string) }
variable "private_subnet_names" {
  type    = list(string)
  default = ["AEH-private-a", "AEH-private-b"]
}

# --- Sécurité ---
variable "monitoring_allowed_cidr" { type = string }
variable "allowed_ssh_cidr"        { type = string }

# --- Load balancer ---
variable "target_port" {
  type    = number
  default = 80
}

variable "health_check_path" {
  type    = string
  default = "/"
}

# --- Autoscaling / Compute ---
variable "ami_id" { type = string }

variable "instance_type" {
  type    = string
  default = "t3.micro"
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
