locals {
  default_lambda_conf = {
    name                                   = "aws-amplify-zip-deployer-from-s3"
    description                            = "An automated workflow to deploy ZIP bundles from S3 to an AWS Amplify static website"
    memory_size                            = 256
    timeout                                = 60
    reserved_concurrent_executions         = 1
    cloudwatch_log_group_retention_in_days = 1
  }
  # It seems that the input variable var.lambda_function contains null values when the user provides  a subset of supported
  # values. This is a workaround to filter out the null values from it such that the merge function does not set to null the default
  # values.
  normalized_lambda_conf = { for k, v in var.lambda_function : k => v if v != null }
  final_lambda_conf      = merge(local.default_lambda_conf, local.normalized_lambda_conf)
}

module "main" {
  source                                 = "babbel/lambda-with-inline-code/aws"
  version                                = "1.6.0"
  function_name                          = local.final_lambda_conf.name
  description                            = local.final_lambda_conf.description
  runtime                                = "python3.12"
  source_dir                             = "${path.module}/bin"
  memory_size                            = local.final_lambda_conf.memory_size
  timeout                                = local.final_lambda_conf.timeout
  reserved_concurrent_executions         = local.final_lambda_conf.reserved_concurrent_executions
  cloudwatch_log_group_retention_in_days = local.final_lambda_conf.cloudwatch_log_group_retention_in_days
  environment_variables = {
    AWS_AMPLIFY_APP_ID                 = var.aws_amplify_app.id
    AWS_AMPLIFY_DEPLOYMENT_BRANCH_NAME = var.aws_amplify_app.deployment_name
    AWS_S3_BUCKET_NAME                 = var.aws_s3_bucket_store.bucket_name
    AWS_S3_KEY                         = format("%s/%s", trimsuffix(var.aws_s3_bucket_store.bucket_path, "/"), var.aws_s3_bucket_store.zip_file_name)
    REGION                             = var.aws_s3_bucket_store.region
  }
  handler = "main.lambda_handler"
  tags    = var.tags
}
