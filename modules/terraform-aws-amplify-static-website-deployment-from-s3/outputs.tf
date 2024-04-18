output "lambda" {
  description = "Full configuration object for the Lambda function that downloads ZIP bundles from S3 and pushes to AWS Amplify website"
  value = {
    config = local.final_lambda_conf
    arn    = module.main.this.arn
    role = {
      id   = module.main.iam_role.id
      arn  = module.main.iam_role.arn
      name = module.main.iam_role.name
    }
    cloudwatch_log_group = {
      arn = module.main.cloudwatch_log_group.arn
    }
  }
}
