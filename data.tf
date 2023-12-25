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

# data "aws_subnet" "selected" {
#   data.aws_vpc.selected.id
#   id       = each.value
# }

output "subnet_cidr_blocks" {
  value = slice(data.aws_subnets.available.ids, 0, 3) #[for s in data.aws_subnet.available.ids : s.ids]
}