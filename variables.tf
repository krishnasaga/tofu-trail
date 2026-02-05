variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "serverless-app"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for static content"
  type        = string
  default     = "hit-counter-bucket"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "counters"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "hit-counter"
}

variable "api_gateway_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "hit-counter-api"
}

variable "cloudfront_price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}
