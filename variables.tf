variable "tags" {
  type = map(any)
  default = {
    "Env"   = "Dev"
    "Owner" = "MiE-tfCloud"
  }
  description = "Resource tags"
}

variable "instance_name" {
  type        = map(any)
  default     = {
    # gitOps_tf_ansible = {
    #     type = "t2.micro",
    #     image = "ami-06a0cd9728546d178"
    # },
    # ecommerce = {
    #     type = "t2.micro",
    #     image = "ami-032930428bf1abbff"
    # }
  }
  description = "EC2 server name and type"
} 
variable "s3_bucket_tf_state" {
  type = string
  default = ""
}
variable "tf_state_key" {
  type = string
  default = ""
}
variable "region" {
  type = string
  default = "us-east-1"
}
variable "subnet_id" {
  type = string
  default = "us-east-1"
}
variable "vpc_id" {
  type = string
  default = "us-east-1"
}
variable "key_name" {
  type = string
  default = "us-east-1"
}
variable "iam_instance_profile" {
  type = string
  default = "us-east-1"
}