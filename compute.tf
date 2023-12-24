resource "aws_instance" "public_ec3" {
  for_each      = var.instance_name
  ami           = each.value["image"]
  instance_type = each.value["type"]
  subnet_id     = "subnet-0d8239bfc96aef6a1"
  key_name      = "smyndlo-key" #"ec2-dev-keypair-pem" 
  iam_instance_profile = "SSM-EC2"

  #user_data_base64 = base64encode(data.template_file.asg_user_data.rendered)

  security_groups = [ "${aws_security_group.public_ec3_sg[0].id}" ]
  lifecycle {
    ignore_changes = [
      security_groups
    ]
  }

  tags = merge(var.tags,
    {
      Name = "${each.key}"
  })
}

data "aws_instances" "public_ip" {
  for_each      = var.instance_name
  instance_tags = {
    Name = "${each.key}"
  }
}

locals {
  public_ips = {
    for key, instance in aws_instance.public_ec3 :
    key => instance.public_ip
  }
}

output "ec2_public_ips" {
  value = [ for k, v in local.public_ips: v ]
}

output "length" {
  value = length(var.instance_name)
}


resource "aws_ecr_repository" "name" {
  for_each             = toset(var.repo_names)
  name                 = "${var.project}/${each.value}"
  image_tag_mutability = "MUTABLE"

#  dynamic "encryption_configuration" {
#    for_each = var.encryption_configuration == null ? [] : [var.encryption_configuration]
#    content {
#      encryption_type = encryption_configuration.value.encryption_type
#      kms_key         = encryption_configuration.value.kms_key
#    }
#  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

variable "repo_names" {
  type = list(string)
  default = ["test-repo"]
}

variable "project" {
  type = string 
  default = "grtz"
}

variable "region" {
    default = "us-east-1"
}