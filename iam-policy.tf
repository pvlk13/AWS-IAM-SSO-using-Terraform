resource "aws_iam_policy" "force_mfa" {
  name        = "Force-MFA-Policy"
  path        = "/"
  description = "Allows users to manage their own MFA and denies everything else without MFA"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowViewAccountInfo"
        Effect = "Allow"
        Action = [
          "iam:GetAccountPasswordPolicy",
          "iam:GetAccountSummary",
          "iam:ListVirtualMFADevices"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowManageOwnMFA"
        Effect = "Allow"
        Action = [
          "iam:CreateVirtualMFADevice",
          "iam:DeleteVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ResyncMFADevice",
          "iam:ListMFADevices"
        ]
        # Only allow them to manage their own MFA device
        Resource = [
         "arn:aws:iam::*:mfa/$${aws:username}",
         "arn:aws:iam::*:user/*$${aws:username}"
        ]
      },
      {
        Sid    = "DenyAllExceptMFAMgmtIfNoMFA"
        Effect = "Deny"
        # Everything EXCEPT these actions is denied if MFA is missing
        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ListVirtualMFADevices",
          "iam:ListMFADevices",
          "iam:ResyncMFADevice",
          "iam:ChangePassword",
          "sts:GetSessionToken",
          "iam:GetUser",
          "iam:GetAccountPasswordPolicy",            
          "iam:ChangePassword",
          "iam:CreateServiceLinkedRole", 
          "sso:*",      
          "sts:GetSessionToken"

        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# Set a strict password policy for the AWS accountß
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention = 5
  max_password_age = 90
}