variable "name" {
  type        = string
  description = "The name of the web site"
}

variable "deployment_name" {
  type        = string
  description = "The name of the default deployment name for the targeted website"
  default     = "main"
}

variable "username" {
  type        = string
  description = "The username of the user"
  default     = ""
}

variable "password" {
  type        = string
  description = "The password of the user"
  sensitive   = true
  default     = ""
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

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources"
  default     = {}
}
