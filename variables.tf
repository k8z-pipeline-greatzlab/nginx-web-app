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