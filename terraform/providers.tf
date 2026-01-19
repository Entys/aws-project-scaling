terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3" # PARIS
}

# module "monitoring" {
 # source = "./modules/monitoring"
 # count  = var.enable_monitoring ? 1 : 0

  # inputs nécessaires (vpc, subnets, tags, etc.)
# }