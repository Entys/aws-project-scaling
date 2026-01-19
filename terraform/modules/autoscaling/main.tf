locals {
  name = var.name != "" ? var.name : "app"
}

resource "aws_security_group" "ec2" {
  name        = "${local.name}-ec2-sg"
  description = "EC2 instances in ASG: HTTP from ALB SG + SSH from allowed CIDR"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  ingress {
    description = "SSH from allowed CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name}-ec2-sg" }
}

resource "aws_launch_template" "this" {
  name_prefix   = "${local.name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.ec2.id]

  metadata_options {
    http_tokens = "required"
  }

  user_data = var.user_data != "" ? base64encode(var.user_data) : null

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "${local.name}-asg-instance" }
  }

  tag_specifications {
    resource_type = "volume"
    tags = { Name = "${local.name}-asg-volume" }
  }
}

resource "aws_autoscaling_group" "this" {
  name                = "${local.name}-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [var.target_group_arn]

  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${local.name}-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = local.name
    propagate_at_launch = true
  }
}
