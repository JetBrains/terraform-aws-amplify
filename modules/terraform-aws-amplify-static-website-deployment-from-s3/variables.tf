variable "lambda_function" {
  type = object({
    name                                   = optional(string)
    description                            = optional(string)
    memory_size                            = optional(number)
    timeout                                = optional(number)
    reserved_concurrent_executions         = optional(number)
    cloudwatch_log_group_retention_in_days = optional(number)
  })
  description = "The configuration parameters of the lambda function"
  default     = {}
}

variable "aws_s3_bucket_store" {
  type = object({
    bucket_name   = string
    bucket_path   = string
    zip_file_name = string
    region        = string
  })
  validation {
    condition     = endswith(var.aws_s3_bucket_store.zip_file_name, ".zip")
    error_message = "The provided file name does not have a ZIP extension. It does not end in .zip"
  }
  description = "The AWS S3 details where the ZIP bundle that needs to be deployed is stored"
}

variable "aws_amplify_app" {
  type = object({
    id              = string
    deployment_name = string
  })
  description = "The AWS Amplify app ID and deployment (branch) name where to deploy the ZIP bundle with static files"
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to the resources"
  default     = {}
}
