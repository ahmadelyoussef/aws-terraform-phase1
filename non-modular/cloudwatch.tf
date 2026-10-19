resource "aws_sns_topic" "phase1_cpu_alerts" {
  name = "tf-phase1-cpu-alerts"

  tags = {
    Name = "tf-phase1-cpu-alerts"
  }
}

# Subscribe an email address to our SNS topic.
# AWS sends a confirmation email before notifications begin.

resource "aws_sns_topic_subscription" "phase1_cpu_email" {
  topic_arn = aws_sns_topic.phase1_cpu_alerts.arn
  protocol  = "email"
  endpoint  = "example@gmail.com"
}

# Monitor average CPU utilization across our ASG instances.
# Send an SNS notification when CPU exceeds 80%
# for 3 consecutive one-minute periods.

resource "aws_cloudwatch_metric_alarm" "phase1_high_cpu" {
  alarm_name        = "tf-phase1-high-cpu"
  alarm_description = "Alert when ASG average CPU exceeds 80%"

  # AWS publishes EC2 CPU metrics in the AWS/EC2 namespace.
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  # Monitor instances belonging to our Auto Scaling Group.
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.phase1_asg.name
  }

  # Calculate average CPU utilization.
  statistic = "Average"

  # Evaluate one-minute periods.
  period = 60

  # Alarm if CPU exceeds 80% for 3 evaluation periods.
  evaluation_periods  = 3
  comparison_operator = "GreaterThanThreshold"
  threshold           = 80

  # Send a notification when the alarm enters ALARM state.
  alarm_actions = [
    aws_sns_topic.phase1_cpu_alerts.arn
  ]
}

resource "aws_cloudwatch_log_group" "phase1_apache_logs" {
  name              = "/tf-phase1/apache"
  retention_in_days = 7

  tags = {
    Name = "tf-phase1-apache-logs"
  }
}