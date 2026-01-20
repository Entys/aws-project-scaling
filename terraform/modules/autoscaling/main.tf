locals {
  name = var.name != "" ? var.name : "app"
}

# -------------------------
# Launch Template
# -------------------------
resource "aws_launch_template" "this" {
  name_prefix   = "${local.name}-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.ec2_sg_id]

  metadata_options {
    http_tokens = "required"
  }

  user_data = var.user_data != "" ? base64encode(var.user_data) : null

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${local.name}-asg-instance"
      Environment = "prod"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name        = "${local.name}-asg-volume"
      Environment = "prod"
    }
  }
}


# -------------------------
# Auto Scaling Group
# -------------------------
resource "aws_autoscaling_group" "this" {
  name                = "${local.name}-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.private_subnet_ids

  # Intégration ALB via Target Group
  target_group_arns = [var.target_group_arn]

  # Health check via ALB
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

# -------------------------
# Scaling Policies
# -------------------------
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${local.name}-cpu-scale-out"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${local.name}-cpu-scale-in"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300
}

# -------------------------
# CloudWatch Alarms
# -------------------------
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${local.name}-asg-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = 50

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${local.name}-asg-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 30
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.this.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}
