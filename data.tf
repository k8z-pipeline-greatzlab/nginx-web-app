data "aws_instances" "public_ip" {
  for_each      = var.instance_name
  instance_tags = {
    Name = "${each.key}"
  }
}