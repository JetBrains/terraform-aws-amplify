<!-- BEGIN_TF_DOCS -->
# terraform-aws-amplify

[![official JetBrains project](https://jb.gg/badges/official.svg)](https://confluence.jetbrains.com/display/ALL/JetBrains+on+GitHub)

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

No providers.
## Resources

No resources.
## Inputs

No inputs.
## Outputs

No outputs.
<!-- END_TF_DOCS -->