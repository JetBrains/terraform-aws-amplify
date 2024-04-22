# terraform-aws-amplify-static-website-deployment-from-s3

Terraform module to deploy a static website to AWS Amplify Console from a given S3 bucket.

<!-- BEGIN_TF_DOCS -->
# terraform-aws-amplify-static-website-deployment-from-s3

[![official JetBrains project](https://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

This module allows a hosted ZIP bundle that stored on S3 to be pushed on an AWS Amplify static web site.

The module expects to operate in the same account where the S3 bucket is hosted.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.20 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.20 |
## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy.additional_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_lambda_invocation.run_at_creation_time](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_permission.enable_s3_to_trigger_main_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_s3_bucket_notification.folder_created_or_updated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.additional_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_bucket.with_zip_bundle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_amplify_app"></a> [aws\_amplify\_app](#input\_aws\_amplify\_app) | The AWS Amplify app ID and deployment (branch) name where to deploy the ZIP bundle with static files | <pre>object({<br>    id              = string<br>    deployment_name = string<br>  })</pre> | n/a | yes |
| <a name="input_aws_s3_bucket_store"></a> [aws\_s3\_bucket\_store](#input\_aws\_s3\_bucket\_store) | The AWS S3 details where the ZIP bundle that needs to be deployed is stored | <pre>object({<br>    bucket_name   = string<br>    bucket_path   = string<br>    zip_file_name = string<br>    region        = string<br>  })</pre> | n/a | yes |
| <a name="input_lambda_function"></a> [lambda\_function](#input\_lambda\_function) | The configuration parameters of the lambda function | <pre>object({<br>    name                                   = optional(string)<br>    description                            = optional(string)<br>    memory_size                            = optional(number)<br>    timeout                                = optional(number)<br>    reserved_concurrent_executions         = optional(number)<br>    cloudwatch_log_group_retention_in_days = optional(number)<br>  })</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The tags to apply to the resources | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda"></a> [lambda](#output\_lambda) | Full configuration object for the Lambda function that downloads ZIP bundles from S3 and pushes to AWS Amplify website |
<!-- END_TF_DOCS -->
