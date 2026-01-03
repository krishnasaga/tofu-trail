variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "my-tofu-bucket"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
