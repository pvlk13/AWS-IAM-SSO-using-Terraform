# AWS IAM & SSO Management with terraform

## Overview
This demo demonstrates how to manage AWS IAM users, groups, and group memberships using Terraform and a CSV file as the data source.

## Quick Start 
### 1. Creation of Backend Bucket for storing the terraform lock file
```hcl
terraform {
   backend s3 {
        bucket = "my-tf-state-bucket-vijaya"
        key    = "terraform.tfstate"
        region = "us-east-1"
    }
}
```hcl