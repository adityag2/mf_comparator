# 🏗️ Terraform Infrastructure

This directory contains the Terraform configuration for deploying the MF Comparator React app to AWS Lambda + API Gateway.

## 📁 Files

- `main.tf` - Main infrastructure configuration
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `provider.tf` - AWS provider configuration

## 🚀 Quick Start

### Prerequisites
1. **Terraform** installed (>= 1.0)
2. **AWS CLI** configured
3. **Node.js** and pnpm for building

### Deploy

```bash
# From project root
pnpm run deploy:build

# Or manually
pnpm run build
cd infra
terraform init
terraform apply
```

### Custom Domain (Optional)

```bash
cd infra
terraform apply \
  -var="domain_name=api.yourdomain.com" \
  -var="certificate_arn=arn:aws:acm:region:account:certificate/cert-id"
```

## 🔧 Configuration

### Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-east-1` |
| `domain_name` | Custom domain | `""` |
| `certificate_arn` | SSL certificate ARN | `""` |
| `environment` | Deployment environment | `prod` |

### Resources Created

- **Lambda Function**: Serves React app + API proxy
- **API Gateway**: Routes requests to Lambda
- **IAM Role**: Lambda execution permissions
- **Custom Domain** (optional): Route53 + API Gateway domain
- **Route53 Record** (optional): DNS for custom domain

## 📊 Outputs

```bash
terraform output
```

- `api_gateway_url` - Application URL
- `lambda_function_name` - Lambda function name
- `lambda_function_arn` - Lambda function ARN
- `api_gateway_id` - API Gateway ID
- `custom_domain` - Custom domain (if configured)

## 🛠️ Commands

```bash
# Initialize
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy

# View outputs
terraform output
```

## 🔍 Troubleshooting

### Common Issues

1. **Build fails**: Ensure `pnpm run build` completes successfully
2. **Lambda timeout**: Increase timeout in `main.tf`
3. **CORS issues**: Check Lambda function CORS headers
4. **Custom domain not working**: Verify SSL certificate and DNS

### Debug

```bash
# View Lambda logs
aws logs tail /aws/lambda/mf-comparator-prod --follow

# Test API Gateway
curl https://your-api-gateway-url.amazonaws.com/prod/

# Check Terraform state
terraform show
```

## 💰 Cost Optimization

- **Lambda**: Pay per request (~$0.20 per 1M requests)
- **API Gateway**: $3.50 per million requests
- **Route53**: ~$0.50/month per hosted zone
- **Custom Domain**: Free with ACM certificate

## 🔐 Security

- HTTPS enforced for custom domains
- CORS headers configured
- IAM roles with minimal permissions
- API Gateway throttling available

---

**Infrastructure as Code with Terraform! 🎉** 