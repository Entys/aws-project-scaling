terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3" # PARIS
}
