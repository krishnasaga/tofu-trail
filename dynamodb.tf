# DynamoDB Table
resource "aws_dynamodb_table" "main" {
  name           = "${var.project_name}-${var.dynamodb_table_name}-${var.environment}"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Name = "${var.project_name}-${var.dynamodb_table_name}-${var.environment}"
  }
}

# Initialize hit counter in DynamoDB
resource "aws_dynamodb_table_item" "visits_counter" {
  table_name = aws_dynamodb_table.main.name
  hash_key   = aws_dynamodb_table.main.hash_key

  item = jsonencode({
    id    = { S = "visits" }
    value = { N = "0" }
  })
}
