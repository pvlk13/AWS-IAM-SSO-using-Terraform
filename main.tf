# Reads users from CSV 
locals {
    users = csvdecode(file("users.csv"))
}

# Get AWS Account ID
data "aws_caller_identity" "current" {}

