terraform {
  # required_version = "~> 0.11"
  backend "s3" {
      bucket = var.s3_bucket_tf_state
      encrypt = "true"
      key     = var.tf_state_key
      region  = var.region
  }
}