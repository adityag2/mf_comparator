# API Gateway
resource "aws_api_gateway_rest_api" "mf_comparator" {
  name        = "mf-comparator-api-${var.environment}"
  description = "API Gateway for MF Comparator Lambda"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway Resource for proxy
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.mf_comparator.id
  parent_id   = aws_api_gateway_rest_api.mf_comparator.root_resource_id
  path_part   = "{proxy+}"
}

# API Gateway Method for proxy
resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.mf_comparator.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# API Gateway Method for root
resource "aws_api_gateway_method" "root_method" {
  rest_api_id   = aws_api_gateway_rest_api.mf_comparator.id
  resource_id   = aws_api_gateway_rest_api.mf_comparator.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mf_comparator.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.mf_comparator.execution_arn}/*/*"
}

# API Gateway Integration for proxy
resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.mf_comparator.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.mf_comparator.invoke_arn
}

# API Gateway Integration for root
resource "aws_api_gateway_integration" "root" {
  rest_api_id = aws_api_gateway_rest_api.mf_comparator.id
  resource_id = aws_api_gateway_rest_api.mf_comparator.root_resource_id
  http_method = aws_api_gateway_method.root_method.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.mf_comparator.invoke_arn
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.proxy,
    aws_api_gateway_integration.root
  ]
  
  rest_api_id = aws_api_gateway_rest_api.mf_comparator.id
  # stage_name  = var.environment
  
  lifecycle {
    create_before_destroy = true
  }
}

   resource "aws_api_gateway_stage" "main" {
     rest_api_id   = aws_api_gateway_rest_api.mf_comparator.id
     deployment_id = aws_api_gateway_deployment.deployment.id
     stage_name    = var.environment
   }

# Custom Domain (optional)
resource "aws_api_gateway_domain_name" "custom" {
  domain_name     = var.domain_name
  certificate_arn = data.aws_acm_certificate.wildcard.arn
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway Base Path Mapping (optional)
resource "aws_api_gateway_base_path_mapping" "custom" {
  api_id      = aws_api_gateway_rest_api.mf_comparator.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  domain_name = aws_api_gateway_domain_name.custom.domain_name
}

# Route53 Record (optional)
resource "aws_route53_record" "apigw_subdomain" {
  zone_id = data.aws_route53_zone.root.zone_id
  name    = var.domain_name
  type    = "A"
  
  alias {
    name                   = aws_api_gateway_domain_name.custom.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.custom.regional_zone_id
    evaluate_target_health = false
  }
} 