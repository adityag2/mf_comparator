output "api_gateway_url" {
  description = "API Gateway URL for the deployed application"
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}"
}

output "lambda_function_name" {
  description = "Name of the deployed Lambda function"
  value       = aws_lambda_function.mf_comparator.function_name
}

output "lambda_function_arn" {
  description = "ARN of the deployed Lambda function"
  value       = aws_lambda_function.mf_comparator.arn
}

output "api_gateway_id" {
  description = "ID of the API Gateway"
  value       = aws_api_gateway_rest_api.mf_comparator.id
}

output "custom_domain" {
  description = "Custom domain name (if configured)"
  value       = var.domain_name != "" ? aws_api_gateway_domain_name.custom[0].domain_name : "Not configured"
}