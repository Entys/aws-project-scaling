# Provider
#=========================================================
provider "aws" {
  region = "eu-west-3"
}

# Variables locales (infra imposée)
#=========================================================

locals {
  vpc_id    = "vpc-0ca8aacebed836262"                                       
# à modifier --------------------------------------------------------------------------------
  subnet_id = "subnet-0b44df42566d7a2e4"
# à modifier --------------------------------------------------------------------------------
}

# Security Groups EXISTANTS
# Dans variables --------------------------------------------------------------------------------
#=========================================================
data "aws_security_group" "monitoring_sg" {
  id = "sg-01a09f8c4347acaa3"
}

# IAM Role pour Prometheus (EC2 SD)
#=========================================================
resource "aws_iam_role" "prometheus_role" {
  name = "prometheus-ec2-sd-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "prometheus_policy" {
  name = "prometheus-ec2-sd-policy"
  role = aws_iam_role.prometheus_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = [
        "ec2:DescribeInstances",
        "ec2:DescribeTags"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "prometheus_profile" {
  name = "prometheus-instance-profile"
  role = aws_iam_role.prometheus_role.name
}

################################
# Key Pair
################################
#resource "aws_key_pair" "monitoring_key" {
#  key_name   = "monitoring-key"
#  public_key = file("C:/Users/aurel/.ssh/id_rsa.pub")
#}

# Génération clé RSA
#=========================================================
resource "tls_private_key" "monitoring_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "monitoring_key" {
  key_name   = "monitoring-key"
  public_key = tls_private_key.monitoring_key.public_key_openssh
}

resource "local_file" "monitoring_private_key" {
  filename        = "${path.module}/monitoring-key.pem"
  content         = tls_private_key.monitoring_key.private_key_pem
  file_permission = "0600"
}

# EC2 Monitoring (Prometheus + Grafana)
#=========================================================
resource "aws_instance" "monitoring" {
  ami                         = "ami-0f95dedaf2f938d49"
  instance_type               = "t2.micro"
  subnet_id                   = local.subnet_id
  key_name                    = aws_key_pair.monitoring_key.key_name
  vpc_security_group_ids      = [data.aws_security_group.monitoring_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.prometheus_profile.name
  associate_public_ip_address = true

  user_data = file(
    "../monitoring/setup-monitoring.sh"
  )

  tags = {
    Name        = "monitoring-server"
    Environment = "prod"
  }
}

