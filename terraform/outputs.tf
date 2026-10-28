output "s3_bucket_name" {
  description = "Name of the created private S3 bucket"
  value       = aws_s3_bucket.site.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.site.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution for cache invalidations"
  value       = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_domain_name" {
  description = "Public HTTPS URL of the CloudFront CDN endpoint"
  value       = "https://${aws_cloudfront_distribution.cdn.domain_name}"
}
