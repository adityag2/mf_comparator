# Lambda IAM Role
resource "aws_iam_role" "lambda_exec" {
  name = "mf-comparator-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda execution
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "mf_comparator" {
  function_name = "mf-comparator-${var.environment}"
  description   = "MF Comparator React SPA with API proxy"
  handler       = "lambda.handler"
  runtime       = "nodejs18.x"
  filename      = "../../build/lambda.zip"
  source_code_hash = filebase64sha256("../../build/lambda.zip")
  
  memory_size = 512
  timeout     = 30
  
  environment {
    variables = {
      API_BASE_URL = "https://api.mfapi.in"
      NODE_ENV     = var.environment
    }
  }
  
  role = aws_iam_role.lambda_exec.arn
} 