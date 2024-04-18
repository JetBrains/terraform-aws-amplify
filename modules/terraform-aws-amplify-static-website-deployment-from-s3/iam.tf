data "aws_caller_identity" "current" {}

locals {
  s3_bucket_key = format("arn:aws:s3:::%s/%s/%s", var.aws_s3_bucket_store.bucket_name, trimsuffix(var.aws_s3_bucket_store.bucket_path, "/"), var.aws_s3_bucket_store.zip_file_name)
}

resource "aws_iam_role_policy" "additional_policy" {
  name   = "additional_policy"
  role   = module.main.iam_role.id
  policy = data.aws_iam_policy_document.additional_policy.json
}

data "aws_iam_policy_document" "additional_policy" {
  statement {
    sid = "AllowToPullFromSourceS3BucketSpecificArtifact"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      local.s3_bucket_key
    ]
  }
  statement {
    sid = "AllowToInitiateAndExecuteManualDeployment"
    actions = [
      "amplify:StartDeployment",
      "amplify:CreateDeployment"
    ]
    resources = [
      format("arn:aws:amplify:%s:%s:apps/%s/branches/%s/deployments/start", var.aws_s3_bucket_store.region, data.aws_caller_identity.current.account_id, var.aws_amplify_app.id, var.aws_amplify_app.deployment_name),
      format("arn:aws:amplify:%s:%s:apps/%s/branches/%s/*", var.aws_s3_bucket_store.region, data.aws_caller_identity.current.account_id, var.aws_amplify_app.id, var.aws_amplify_app.deployment_name)
    ]
  }
}
