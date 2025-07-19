# 🚀 AWS Lambda + API Gateway Deployment Guide (Terraform)

## Overview
This guide will help you deploy the MF Comparator React app to AWS Lambda with API Gateway using Terraform, making it accessible via a custom domain.

## 📋 Prerequisites

1. **AWS CLI configured** with appropriate permissions
2. **Node.js 18+** and pnpm installed
3. **Terraform** installed (version >= 1.0)
4. **Domain name** (optional, for custom domain)
5. **SSL Certificate** in AWS Certificate Manager (for HTTPS)

## 🛠️ Step 1: Build the Application

```bash
# Install dependencies
pnpm install

# Build for production
pnpm run build
```

## 🚀 Step 2: Deploy to AWS Lambda

### Option A: Quick Deploy (Default API Gateway URL)
```bash
# Deploy using the provided script
bash deploy-terraform.sh

# Or manually
pnpm run deploy:build
```

### Option B: Custom Domain Setup

1. **Create SSL Certificate** (if you have a domain):
   ```bash
   # Request certificate in ACM
   aws acm request-certificate \
     --domain-name api.yourdomain.com \
     --validation-method DNS
   ```

2. **Deploy with custom domain**:
   ```bash
   # Update infra/variables.tf with your domain
   # Then deploy
   cd infra
   terraform apply -var="domain_name=api.yourdomain.com" -var="certificate_arn=arn:aws:acm:..."
   ```

## 🌐 Step 3: Configure Custom Domain

### Using Terraform (Recommended)

1. **Update the variables** with your domain:
   ```hcl
   # In infra/variables.tf or via command line
   domain_name = "api.yourdomain.com"
   certificate_arn = "arn:aws:acm:region:account:certificate/cert-id"
   ```

2. **Deploy with custom domain**:
   ```bash
   cd infra
   terraform apply -var="domain_name=api.yourdomain.com" -var="certificate_arn=arn:aws:acm:..."
   ```

### Manual Setup (Alternative)

1. **Create API Gateway Custom Domain**:
   - Go to API Gateway Console
   - Create Custom Domain Name
   - Attach SSL certificate
   - Map to your API

2. **Configure Route53**:
   - Create A record pointing to API Gateway
   - Use alias target for the custom domain

## 📊 Step 4: Verify Deployment

### Check Deployment Status
```bash
# Get deployment info
cd infra && terraform output

# Test the API
curl https://your-api-gateway-url.amazonaws.com/prod/
```

### Expected URLs
- **API Gateway**: `https://abc123.execute-api.us-east-1.amazonaws.com/prod/`
- **Custom Domain**: `https://api.yourdomain.com/`

## 🔧 Configuration Options

### Environment Variables
```hcl
# In infra/main.tf
environment {
  variables = {
    API_BASE_URL = "https://api.mfapi.in"
    NODE_ENV     = "prod"
  }
}
```

### Lambda Settings
```hcl
# In infra/main.tf
resource "aws_lambda_function" "mf_comparator" {
  memory_size = 512
  timeout     = 30
  # ... other settings
}
```

## 🔍 Troubleshooting

### Common Issues

1. **Build fails**:
   ```bash
   # Clear cache and rebuild
   rm -rf build node_modules
   pnpm install
   pnpm run build
   ```

2. **Lambda timeout**:
   - Increase timeout in `serverless.yml`
   - Check API Gateway settings

3. **CORS issues**:
   - Verify CORS headers in `lambda.js`
   - Check API Gateway CORS settings

4. **Custom domain not working**:
   - Verify SSL certificate is valid
   - Check Route53 DNS propagation
   - Verify API Gateway domain mapping

### Debug Commands

```bash
# View Lambda logs
aws logs tail /aws/lambda/mf-comparator-prod --follow

# Test locally
pnpm run serve

# Check API Gateway
aws apigateway get-rest-apis

# Terraform commands
cd infra
terraform plan
terraform apply
terraform destroy
```

## 📈 Monitoring & Scaling

### CloudWatch Metrics
- Monitor Lambda invocations
- Track API Gateway requests
- Set up alarms for errors

### Auto Scaling
- Lambda scales automatically
- API Gateway handles traffic spikes
- Consider CloudFront for global distribution

## 🔐 Security Best Practices

1. **API Keys**: Enable API key requirement
2. **Rate Limiting**: Configure throttling
3. **WAF**: Add Web Application Firewall
4. **HTTPS**: Always use SSL/TLS
5. **CORS**: Restrict origins in production

## 💰 Cost Optimization

- **Lambda**: Pay per request (very cost-effective)
- **API Gateway**: $3.50 per million requests
- **Route53**: ~$0.50/month per hosted zone
- **CloudFront**: Optional for global distribution

## 🚀 Next Steps

1. **Set up monitoring** with CloudWatch
2. **Configure alerts** for errors
3. **Add CloudFront** for global distribution
4. **Implement CI/CD** with GitHub Actions
5. **Add custom domain** for branding

## 📞 Support

For issues:
1. Check CloudWatch logs
2. Verify Lambda function code
3. Test API Gateway endpoints
4. Review serverless.yml configuration

---

**Your React app is now serverless and scalable! 🎉** 