
resource "aws_ssoadmin_permission_set" "department_access" {
  name             = "DepartmentAccess"
  description      = "Grants access to AWS resources based on department membership"
  instance_arn     = tolist(data.aws_ssoadmin_instances.sso_instances.arns)[0]
  session_duration = "PT2H"
}

resource "aws_ssoadmin_managed_policy_attachment" "department_access_attachment" {
  # Note: Check if you still want to loop by IAM groups here, 
  # usually SSO attachments are done per Permission Set.
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso_instances.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.department_access.arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess" # Example policy
}