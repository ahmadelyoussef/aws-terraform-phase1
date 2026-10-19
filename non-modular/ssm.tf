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