variable "vpc_cidr" { type = string }
variable "vpc_name" { type = string }

variable "public_subnet_cidrs" { type = list(string) }
variable "public_subnet_azs"   { type = list(string) }
variable "public_subnet_names" { type = list(string) }

variable "private_subnet_cidrs" { type = list(string) }
variable "private_subnet_azs"   { type = list(string) }
variable "private_subnet_names" { type = list(string) }

variable "monitoring_allowed_cidr" { type = string }
variable "allowed_ssh_cidr"        { type = string }
