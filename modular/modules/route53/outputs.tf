
# Export the Route 53 hosted zone ID.
# The ACM module needs this ID to create DNS validation records.
output "zone_id" {
  description = "Route 53 hosted zone ID"
  value       = aws_route53_zone.phase1_zone.zone_id
}
