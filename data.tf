data "aws_ssoadmin_instances" "sso_instances" {}

locals {
  # Removed the extra underscore after "sso" to match the data source name
  instance_arn      = tolist(data.aws_ssoadmin_instances.sso_instances.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.sso_instances.identity_store_ids)[0] 
}