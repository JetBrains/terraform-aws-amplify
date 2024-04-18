data "aws_s3_bucket" "with_zip_bundle" {
  bucket = var.aws_s3_bucket_store.bucket_name
}

resource "aws_lambda_invocation" "run_at_creation_time" {
  # This invocation should happen at most once when the AWS Amplify app/website is just created
  function_name = local.final_lambda_conf.name
  input         = jsonencode({})
  depends_on    = [module.main]
}

resource "aws_lambda_permission" "enable_s3_to_trigger_main_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.main.this.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.with_zip_bundle.arn
}

resource "aws_s3_bucket_notification" "folder_created_or_updated" {
  # This trigger watches for new zip files in the folder of the targeted S3 bucket
  # Notice that var.source_s3_key points to an existing ZIP file in the S3 bucket
  bucket = data.aws_s3_bucket.with_zip_bundle.id

  lambda_function {
    lambda_function_arn = module.main.this.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.aws_s3_bucket_store.bucket_path
    filter_suffix       = ".zip"
  }

  depends_on = [
    module.main,
    aws_lambda_permission.enable_s3_to_trigger_main_lambda,
  ]
}
