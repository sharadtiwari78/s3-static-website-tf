output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "domain_name"{
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
