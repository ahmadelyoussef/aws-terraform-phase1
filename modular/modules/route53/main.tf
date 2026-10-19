
# Create a public hosted zone for example.com.
# Route 53 automatically creates NS (four nameservers) and SOA records.
# The nameservers must be configured in Namecheap for this zone to be authoritative.
resource "aws_route53_zone" "phase1_zone" {
  name = var.domain_name

  tags = {
    Name = "tf-phase1-hosted-zone"
  }
}

# Create an A (Alias) record for the root domain: example.com.
# zone_id identifies our Route 53 hosted zone.
# alias.name points to the ALB's DNS hostname.
# alias.zone_id identifies the AWS-managed hosted zone of the ALB.
# evaluate_target_health = false means Route 53 does not use ALB health
# when evaluating this DNS record. The ALB still checks EC2 health.
resource "aws_route53_record" "phase1_root" {
  zone_id = aws_route53_zone.phase1_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}

# Create another A (Alias) record for www.example.com.
# Both the root domain and www point to the same ALB.
# We don't need another hosted zone or another set of nameservers.
resource "aws_route53_record" "phase1_www" {
  zone_id = aws_route53_zone.phase1_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}
