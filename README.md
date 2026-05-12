# Terraform Platform Project

## Project Overview
Foundation platform for AWS infrastructure using Infrastructure as Code (IaC).

## Environments
- **Dev**: Development environment (low cost)
- **QA**: Quality Assurance environment (production-like)
- **Prod**: Production environment (hardened)

## Structure
```text
terraform-platform/
├── modules/          # Reusable Terraform modules
│   ├── vpc/         # VPC networking module
│   ├── ec2/         # EC2 instance module
│   ├── s3/          # S3 bucket module
│   └── iam/         # IAM roles and policies module
├── environments/     # Environment-specific configurations
│   ├── dev/         # Development environment
│   ├── qa/          # QA environment
│   └── prod/        # Production environment
└── README.md        # This file
```

## Prerequisites
- Terraform >= 1.0
- AWS CLI configured
- Terraform Cloud account

## Deployment Instructions
See individual environment folders for deployment steps.

## Cost Optimization
- Using Free Tier eligible resources where possible
- t2.micro/t3.micro instances
- Minimal NAT Gateway usage
- S3 lifecycle policies

## Author
Created for learning purposes by Nadia Shabeer - Date: 05/04/2026