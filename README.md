<!-- BEGIN_TF_DOCS -->
# terraform-aws-amplify

[![official JetBrains project](https://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

Note: this module is a work in progress and is not yet ready for use.

AWS Amplify is a development platform for building secure, scalable mobile and web
applications. It offers a broad range of services and features, including
authentication, analytics, API (GraphQL and REST), interactions, and more.
Amplify simplifies the setup of new applications with a CLI interface, and it
integrates with your version control system to enable continuous deployment.
The service provides a unified model to manage backend and frontend development
workflows, and it helps to seamlessly integrate with other AWS services.

## Compatibility

The minimum supported Terraform version is: 1.3.0.

## Repository organization

* [examples](./examples): this folder contains ready to use examples that show how to use this Module;

* [tests](./test): this folder contains a list of automated tests for this Module and examples;

* [lib](./lib): this folder contains a list of local utilities, mostly Makefiles, to support the
  contributor's maintenance effort of this Module;

* [modules](./modules): this folder contains a list of local Terraform modules that the Root Module uses;

* [.github](./.github): this folder contains a list of GitHub workflows to support contributions
  during change requests and releases of this Module.

## Resources

Documentation about the AWS Amplify service can be found [here](https://docs.aws.amazon.com/amplify/).

## Contribution guides

Refer to this [page](./CONTRIBUTING.md) for details in regard to contribution instructions.

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
| [aws_amplify_app.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_app) | resource |
| [aws_amplify_branch.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/amplify_branch) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_s3_bucket_store"></a> [aws\_s3\_bucket\_store](#input\_aws\_s3\_bucket\_store) | The AWS S3 details where the ZIP bundle that needs to be deployed is stored | <pre>object({<br>    bucket_name   = string<br>    bucket_path   = string<br>    zip_file_name = string<br>    region        = string<br>  })</pre> | n/a | yes |
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | The name of the default deployment name for the targeted website | `string` | `"main"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the web site | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | The password of the user | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources | `map(string)` | `{}` | no |
| <a name="input_username"></a> [username](#input\_username) | The username of the user | `string` | `""` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_amplify_site"></a> [amplify\_site](#output\_amplify\_site) | The Amplify site configuration details |
| <a name="output_lambda_config"></a> [lambda\_config](#output\_lambda\_config) | The Lambda function configuration details |
<!-- END_TF_DOCS -->
