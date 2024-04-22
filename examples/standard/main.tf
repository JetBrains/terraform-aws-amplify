module "website_without_basic_authentication" {
  source          = "../.."
  name            = "example-without-basic-auth"
  deployment_name = "test"
  aws_s3_bucket_store = {
    bucket_name   = "cf-templates-e9tp7xxhdvkw-eu-west-1"
    bucket_path   = "website/storybook"
    zip_file_name = "archive.zip"
    region        = "eu-west-1"
  }
  tags = {
    environment = "acceptance-testing"
    repository  = "jetbrains/terraform-aws-amplify"
  }
}
