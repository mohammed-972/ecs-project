output "certificate_arn" {
  value = aws_acm_certificate_validation.cert.certificate_arn
}

output "domain_name" {
  value = aws_acm_certificate.cert.domain_name
}