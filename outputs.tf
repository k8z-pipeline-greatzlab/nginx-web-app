# output "ec2_server_public_ip" {
#   value = "${aws_instance.public_ec3.*.public_ip}"
# }

output "ec2_public_ips" {
  value = [ for k, v in local.public_ips: v ]
}

output "length" {
  value = length(var.instance_name)
}
output "subnet_cidr_blocks" {
  value = slice(data.aws_subnets.available.ids, 0, 3) 
}