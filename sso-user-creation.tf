resource "aws_identitystore_user" "sso_users" {
  for_each = { for u in local.users : u.first_name => u }

  identity_store_id = tolist(data.aws_ssoadmin_instances.sso_instances.identity_store_ids)[0]
  
  # Use the same logic as your IAM users: a.bernard
  user_name = lower("${substr(each.value.first_name, 0, 1)}.${each.value.last_name}")
  
  display_name = "${each.value.first_name} ${each.value.last_name}"

  name {
    given_name  = each.value.first_name
    family_name = each.value.last_name
  }
}

resource "aws_ssoadmin_account_assignment" "account_assignment" {
  for_each = aws_identitystore_user.sso_users

  instance_arn       = tolist(data.aws_ssoadmin_instances.sso_instances.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.department_access.arn
  
  principal_id   = each.value.user_id # Correctly references the created SSO user
  principal_type = "USER"
  
  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}