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