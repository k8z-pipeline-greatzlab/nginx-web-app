data "aws_instances" "public_ip" {
  for_each      = var.instance_name
  instance_tags = {
    Name = "${each.key}"
  }
}

data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "selected" {
  for_each = toset(data.aws_subnets.available.ids)
  id       = each.value
}

output "subnet_cidr_blocks" {
  value = [for s in data.aws_subnet.selected : s.cidr_block]
}