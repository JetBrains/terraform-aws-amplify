module "website_with_basic_authentication" {
  source          = "../.."
  name            = "example-with-basic-auth"
  deployment_name = "test"
  username        = "silky_malvin"
  password        = "not_so_secret"
  aws_s3_bucket_store = {
    bucket_name   = "cf-templates-e9tp7xxhdvkw-eu-west-1"
    bucket_path   = "websites/storybook"
    zip_file_name = "archive.zip"
    region        = "eu-west-1"
  }
  tags = {
    environment = "acceptance-testing"
    repository  = "jetbrains/terraform-aws-amplify"
  }
}
