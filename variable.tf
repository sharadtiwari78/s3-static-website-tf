variable "bucketname" {
  type    = any
  default = "static-website-bucket"
}

variable "codepipeline_name" {
  type = string
  default = "my-s3-website-pipeline"
}

variable "artifact_store_type" {
  type = any
  default = "S3"
}
variable "source_stage" {
  type = string
  default = "Source"
}

variable "owner" {
  type = string
  default = "AWS"
}

variable "source_provider" {
  type = string
  default = "CodeStarSourceConnection"
}

variable "repository_id" {
  type = string
  default = "sharadtiwari78/my-s3-website"
}

variable "branch_name" {
  type = string
  default = "main"
}

variable "deploy_stage" {
  type = string
  default = "Deploy"
}

variable "deploy_provider" {
  type = string
  default = "S3"
}

variable "codestar_connection_name" {
  type = string
  default = "mygithub-connection"
}

variable "codestart_connection_provider_type" {
  type = string
  default = "GitHub"
}

variable "codepipeline_bucket_name" {
  type = string
  default = "s3-website-pipeline"
}

variable "force_destroy" {
  type = bool
  default = true
}

variable "codepipeline_role_name" {
  type = string
  default = "pipeline-role"
}

variable "codepipeline_role_policy" {
  type = string
  default = "codepipeline_policy"
}

variable "s3_origin_id" {
  type = string
  default = "myS3Origin"
}

variable "origin_access_control_name" {
  type = string
  default = "s3_origin"
}

variable "origin_access_control_type" {
  type = string
  default = "s3"
}

variable "origin_access_control_signing_behavior" {
  type = string
  default = "always"
}

variable "origin_access_control_signing_protocol" {
  type = string
  default = "sigv4"
}

variable "cache_behavior" {
  type = list(string)
  default = ["GET", "HEAD", "OPTIONS"]
}

variable "cache_method" {
  type = list(string)
  default = ["GET", "HEAD"]
}

variable "geo_restriction_type" {
  type = string
  default = "whitelist"
}

variable "location" {
  type = list(string)
  default = ["IN"]
}

