# Create IAM users based on the CSV file
resource "aws_iam_user" "users" {
    for_each = { for user in local.users : user.first_name => user }
    name = lower("${substr(each.value.first_name,0,1)}.${each.value.last_name}")
    path = "/users/"

    tags = {
        "DisplayName" = "${each.value.first_name} ${each.value.last_name}"
        "Department" = each.value.department
        "JobTitle"   = each.value.job_title  
    }
}
# Create IAM groups based on the CSV file
resource "aws_iam_group" "departments" {
    for_each = toset([for user in local.users : user.department])
    name = replace(each.key, " ", "-") # Replace spaces with hyphens for group names
    path = "/groups/"
}

# Add users to their respective department groups
resource "aws_iam_group_membership" "dept_membership" {
    for_each = toset([for user in local.users : user.department])
    name = "${each.value}-membership"
    group = aws_iam_group.departments[each.value].name
    users = [for user in local.users : lower("${substr(user.first_name,0,1)}.${user.last_name}") if user.department == each.value]

}

# Create login profiles for each user
resource "aws_iam_user_login_profile" "users" {
  for_each = aws_iam_user.users
  user = each.value.name
  password_reset_required = true   
  lifecycle {
    ignore_changes = [
        password_length,
        password_reset_required
    ]
  }              
}

# Attach the Force MFA policy to all users
resource "aws_iam_group_policy_attachment" "force_mfa_attachment" {
    for_each = aws_iam_group.departments
    group = each.value.name
    policy_arn = aws_iam_policy.force_mfa.arn
}

# This resource doesn't have many arguments; it just tells AWS to be ready to generate reports
resource "aws_iam_account_alias" "alias" {
  account_alias = "my-company-production-iam" # Give your login URL a clean name
}