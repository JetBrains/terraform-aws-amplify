locals {
  enable_basic_auth = var.username != null && var.password != null || var.username != "" && var.password != ""
  tags              = merge(var.tags, { CreatedWith = "Terraform" })
}

resource "aws_amplify_app" "site" {
  name                   = var.name
  enable_basic_auth      = local.enable_basic_auth
  basic_auth_credentials = local.enable_basic_auth ? base64encode(format("%s:%s", var.username, var.password)) : null
  tags                   = local.tags
}

resource "aws_amplify_branch" "site" {
  app_id      = aws_amplify_app.site.id
  branch_name = var.deployment_name
  tags        = local.tags
}

module "aws_amplify_static_website_from_s3" {
  source = "./modules/terraform-aws-amplify-static-website-deployment-from-s3"
  lambda_function = {
    name = var.name
  }
  aws_s3_bucket_store = var.aws_s3_bucket_store
  aws_amplify_app = {
    id              = aws_amplify_app.site.id
    deployment_name = aws_amplify_branch.site.branch_name
  }
  tags = local.tags
}
