#!/bin/bash

echo "🚀 Building React App for Terraform deployment..."

# Build the React app
pnpm run build

echo "📦 Creating Lambda deployment package..."

# Create build directory if it doesn't exist
mkdir -p build

# Copy lambda.js to build directory
cp lambda.js build/

# Create zip file for Lambda
cd build
zip -r lambda.zip lambda.js build/ -x "*.DS_Store" "*.git*"
cd ..

echo "🌐 Initializing Terraform..."
cd infra
terraform init

echo "📋 Planning Terraform deployment..."
terraform plan

echo "🚀 Deploying to AWS..."
terraform apply -auto-approve

echo "✅ Deployment complete!"
echo "🌍 Your app is now available at the API Gateway URL above"
echo "📝 To get the URL, run: cd infra && terraform output" 