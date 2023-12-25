resource "aws_instance" "public_ec3" {
  for_each      = var.instance_name
  ami           = each.value["image"]
  instance_type = each.value["type"]
  subnet_id     = var.subnet_id
  key_name      = var.key_name 
  iam_instance_profile = var.iam_instance_profile

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


