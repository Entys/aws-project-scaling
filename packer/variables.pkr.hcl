variable "app_version" {
  type        = string
  description = "Version de l'application"
}

variable "aws_region" {
  type        = string
  description = "Région AWS où créer l'AMI"
}

variable "instance_type" {
  type        = string
  description = "Type d'instance EC2 pour le build"
  default     = "t2.micro"
}

variable "base_ami_owner" {
  type        = string
  description = "AWS account ID du propriétaire de l'AMI de base"
  default     = "136693071363"
}

variable "base_ami_filter" {
  type        = string
  description = "Filtre pour sélectionner l'AMI de base"
  default     = "debian-12-amd64-*"
}

variable "ssh_username" {
  type        = string
  description = "Username SSH de l'AMI de base"
  default     = "admin"
}