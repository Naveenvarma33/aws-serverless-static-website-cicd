variable "aws_region" {
  description = "AWS region for provisioning resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project identifier prefix"
  type        = string
  default     = "serverless-static-site"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "index_document" {
  description = "Default root document"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "Custom 404 error page"
  type        = string
  default     = "error.html"
}
