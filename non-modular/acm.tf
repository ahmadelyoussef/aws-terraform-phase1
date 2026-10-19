# Request a public SSL/TLS certificate from AWS ACM.
# The certificate covers both example.com and www.example.com.
# RSA 2048 is the key algorithm.
# DNS validation proves that we control the domains.

resource "aws_acm_certificate" "phase1_cert" {
  domain_name               = "example.com"
  subject_alternative_names = ["www.example.com"]
  validation_method         = "DNS"
  key_algorithm             = "RSA_2048"

  tags = {
    Name = "tf-phase1-acm-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create DNS validation CNAME records in Route 53.
# ACM provides the record name and value for each domain.
# Terraform automatically creates the required records.

resource "aws_route53_record" "phase1_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.phase1_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = aws_route53_zone.phase1_zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]

  allow_overwrite = true
}

# Terraform created the CNAME records
# collects their DNS names using validation_record_fqdns 
# and waits for ACM to issue the certificate.

resource "aws_acm_certificate_validation" "phase1_validation" {
  certificate_arn = aws_acm_certificate.phase1_cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.phase1_cert_validation :
    record.fqdn
  ]
}