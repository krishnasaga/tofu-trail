# AWS Serverless Infrastructure with OpenTofu

This project implements a complete serverless infrastructure on AWS using OpenTofu (Terraform). The architecture includes CloudFront, API Gateway, Lambda, DynamoDB, and S3.

## Architecture

```
CloudFront → API Gateway → Lambda → DynamoDB
                ↓            ↓
            S3 Bucket    S3 Bucket
```

### Components

- **CloudFront**: CDN for content delivery and API routing
  - Serves static content from S3
  - Routes `/api/*` requests to API Gateway
  
- **API Gateway (HTTP API)**: RESTful API endpoint
  - Integrated with Lambda function
  - CORS enabled
  - Access logging enabled
  
- **Lambda Function**: Python-based API handler
  - Processes API requests
  - Interacts with DynamoDB and S3
  - Environment variables for configuration
  
- **DynamoDB Table**: NoSQL database
  - Pay-per-request billing
  - Point-in-time recovery enabled
  - TTL enabled
  
- **S3 Bucket**: Object storage
  - Versioning enabled
  - Server-side encryption
  - CloudFront integration with OAC

## Prerequisites

- [OpenTofu](https://opentofu.org/) >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions

## Project Structure

```
tofu-v1/
├── provider.tf        # Provider and backend configuration
├── variables.tf       # Input variables
├── main.tf           # Main infrastructure resources
├── outputs.tf        # Output values
├── lambda/
│   └── index.py      # Lambda function code
└── README.md         # This file
```

## Configuration

### Variables

You can customize the deployment by setting variables in a `terraform.tfvars` file:

```hcl
aws_region          = "us-east-1"
project_name        = "my-serverless-app"
environment         = "dev"
s3_bucket_name      = "my-app-bucket"
dynamodb_table_name = "my-app-table"
```

Available variables:
- `aws_region`: AWS region (default: "us-east-1")
- `project_name`: Project name for resource naming (default: "serverless-app")
- `environment`: Environment name (default: "dev")
- `s3_bucket_name`: S3 bucket name suffix (default: "serverless-app-bucket")
- `dynamodb_table_name`: DynamoDB table name suffix (default: "serverless-app-table")
- `lambda_function_name`: Lambda function name (default: "api-handler")
- `api_gateway_name`: API Gateway name (default: "serverless-api")
- `cloudfront_price_class`: CloudFront pricing tier (default: "PriceClass_100")

## Deployment

### Step 1: Initialize OpenTofu

```bash
tofu init
```

### Step 2: Review the Plan

```bash
tofu plan
```

### Step 3: Apply the Configuration

```bash
tofu apply
```

Type `yes` when prompted to confirm the deployment.

### Step 4: Get Outputs

After successful deployment, view the outputs:

```bash
tofu output
```

## API Endpoints

The Lambda function provides the following endpoints:

### GET /
Returns API information and available endpoints.

**Example:**
```bash
curl https://<cloudfront-domain>/api/
```

### GET /health
Health check endpoint.

**Example:**
```bash
curl https://<cloudfront-domain>/api/health
```

### GET /items
Lists all items from DynamoDB.

**Example:**
```bash
curl https://<cloudfront-domain>/api/items
```

### POST /items
Creates a new item in DynamoDB.

**Example:**
```bash
curl -X POST https://<cloudfront-domain>/api/items \
  -H "Content-Type: application/json" \
  -d '{"data": {"name": "Test Item", "value": 123}}'
```

## Testing

### Direct API Gateway Testing

You can test the API directly through API Gateway (bypass CloudFront):

```bash
# Get the API endpoint
API_URL=$(tofu output -raw direct_api_url)

# Test endpoints
curl $API_URL/
curl $API_URL/health
curl $API_URL/items
```

### CloudFront Testing

Test through CloudFront (recommended for production):

```bash
# Get CloudFront URL
CF_URL=$(tofu output -raw application_url)

# Test API endpoints
curl $CF_URL/api/
curl $CF_URL/api/health
curl $CF_URL/api/items
```

## Monitoring

### CloudWatch Logs

- **Lambda logs**: `/aws/lambda/<function-name>`
- **API Gateway logs**: `/aws/apigateway/<api-name>`

View logs in AWS Console or using AWS CLI:

```bash
aws logs tail /aws/lambda/<function-name> --follow
```

### Metrics

Monitor the following in CloudWatch:
- Lambda invocations, errors, duration
- API Gateway requests, latency, errors
- DynamoDB read/write capacity
- CloudFront requests and error rates

## Cost Optimization

This infrastructure uses cost-effective services:
- DynamoDB: Pay-per-request billing (no idle costs)
- Lambda: Pay only for execution time
- API Gateway HTTP API: Lower cost than REST API
- S3: Standard storage with lifecycle policies
- CloudFront: PriceClass_100 (lowest cost tier)

## Security Features

- S3 bucket encryption at rest (AES-256)
- CloudFront Origin Access Control (OAC) for S3
- Lambda execution role with least privilege
- API Gateway CORS configuration
- DynamoDB encryption at rest (default AWS managed keys)
- Private S3 bucket (no public access)

## Cleanup

To destroy all resources:

```bash
tofu destroy
```

Type `yes` when prompted to confirm deletion.

**Warning**: This will delete all resources including data in DynamoDB and S3.

## Troubleshooting

### Lambda Function Not Deploying

Ensure the Lambda code exists:
```bash
ls -la lambda/index.py
```

### API Gateway 403 Errors

Check Lambda permissions for API Gateway invocation:
```bash
aws lambda get-policy --function-name <function-name>
```

### CloudFront Not Serving Content

- Wait 10-15 minutes for CloudFront distribution to fully deploy
- Check CloudFront distribution status in AWS Console
- Verify S3 bucket policy allows CloudFront access

### DynamoDB Access Issues

Check Lambda execution role has DynamoDB permissions:
```bash
tofu output lambda_role_arn
```

## Additional Resources

- [OpenTofu Documentation](https://opentofu.org/docs/)
- [AWS Lambda Documentation](https://docs.aws.amazon.com/lambda/)
- [API Gateway Documentation](https://docs.aws.amazon.com/apigateway/)
- [DynamoDB Documentation](https://docs.aws.amazon.com/dynamodb/)
- [CloudFront Documentation](https://docs.aws.amazon.com/cloudfront/)

## License

This project is provided as-is for educational and demonstration purposes.
