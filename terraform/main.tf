################################
# Provider
################################
provider "aws" {
  region = "eu-west-3"
}

################################
# Variables locales (infra imposée)
################################
locals {
  vpc_id    = "vpc-03fd1ebb41b40987f"
  subnet_id = "subnet-01e973e9c44864b90"
}

################################
# Security Groups EXISTANTS
################################
data "aws_security_group" "monitoring_sg" {
  id = "sg-01e7e6857e2fe1293"
}

data "aws_security_group" "app_sg" {
  id = "sg-02430ebfae8a782b9"
}

################################
# IAM Role pour Prometheus (EC2 SD)
################################
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
resource "aws_key_pair" "monitoring_key" {
  key_name   = "monitoring-key"
  public_key = file("C:/Users/aurel/.ssh/id_rsa.pub")
}

################################
# EC2 Monitoring (Prometheus + Grafana)
################################
resource "aws_instance" "monitoring" {
  ami                         = "ami-078abd88811000d7e"
  instance_type               = "t2.micro"
  subnet_id                   = local.subnet_id
  key_name                    = aws_key_pair.monitoring_key.key_name
  vpc_security_group_ids      = [data.aws_security_group.monitoring_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.prometheus_profile.name
  associate_public_ip_address = true

  user_data = file(
    "C:/Users/aurel/Mon Drive/Ecoles/Ynov (Expert Cyber) 2024-2026/Master_1_2025_2026/1 - Infrastructure Cloud/Projet/aws-project-scaling/monitoring/setup-monitoring.sh"
  )

  tags = {
    Name        = "monitoring-server"
    Environment = "prod"
  }
}

################################
# Launch Template pour EC2 applicatives
################################
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = "ami-0e471cb4ee10dbad7"   # AMI applicative
  instance_type = "t2.micro"
  key_name      = aws_key_pair.monitoring_key.key_name

  vpc_security_group_ids = [
    data.aws_security_group.app_sg.id
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "app-instance"
      Environment = "prod"
    }
  }
}

################################
# Auto Scaling Group
################################
resource "aws_autoscaling_group" "app_asg" {
  name                = "app-asg"
  min_size            = 1
  max_size            = 5
  desired_capacity    = 1
  vpc_zone_identifier = [local.subnet_id]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  health_check_type = "EC2"
}
