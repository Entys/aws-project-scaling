variable "region" {
  type    = string
  default = "eu-west-3"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "monitoring_sg_ids" {
  type = list(string)
}



