
# =========================
# SNS TOPIC
# =========================

resource "aws_sns_topic" "phase1_cpu_alerts" {
  name = "tf-phase1-cpu-alerts"

  tags = {
    Name = "tf-phase1-cpu-alerts"
  }
}

# =========================
# SNS EMAIL SUBSCRIPTION
# =========================

resource "aws_sns_topic_subscription" "phase1_cpu_email" {
  topic_arn = aws_sns_topic.phase1_cpu_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# =========================
# CLOUDWATCH CPU ALARM
# =========================

resource "aws_cloudwatch_metric_alarm" "phase1_high_cpu" {
  alarm_name        = "tf-phase1-high-cpu"
  alarm_description = "Alert when ASG average CPU exceeds 80%"

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  statistic = "Average"

  period = 60

  evaluation_periods  = 3
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.cpu_threshold

  alarm_actions = [
    aws_sns_topic.phase1_cpu_alerts.arn
  ]
}

# =========================
# CLOUDWATCH LOG GROUP
# =========================

resource "aws_cloudwatch_log_group" "phase1_apache_logs" {
  name              = "/tf-phase1/apache"
  retention_in_days = 7

  tags = {
    Name = "tf-phase1-apache-logs"
  }
}


resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  name = "/tf-phase1/cloudwatch-agent/config"
  type = "String"

  value = jsonencode({
    logs = {
      logs_collected = {
        files = {
          collect_list = [
            {
              file_path       = "/var/log/httpd/access_log"
              log_group_name  = aws_cloudwatch_log_group.phase1_apache_logs.name
              log_stream_name = "{instance_id}/access"
            },
            {
              file_path       = "/var/log/httpd/error_log"
              log_group_name  = aws_cloudwatch_log_group.phase1_apache_logs.name
              log_stream_name = "{instance_id}/error"
            }
          ]
        }
      }
    }
  })
}
