output "account_id" {
    value = data.aws_caller_identity.current.account_id
}

output "user_name" {
  value = [for user in aws_iam_user.users : user.name]
}

output "department_groups" {
  value = [for group in aws_iam_group.departments : group.name] 
  
}

output "department_group_membership" {
  value = [for membership in aws_iam_group_membership.dept_membership : {
    group = membership.group
    users = membership.users
  }]
  
}

output "group_policy_mapping" {
  # This creates a map: "Sales" = "arn:aws:iam..."
  value = { for k, v in aws_iam_group_policy_attachment.force_mfa_attachment : k => v.policy_arn }
}

output "sso_user_names" {
  value = [for user in aws_identitystore_user.sso_users : user.user_name]
  
}   