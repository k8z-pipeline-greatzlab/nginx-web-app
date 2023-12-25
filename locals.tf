locals {
  public_ips = {
    for key, instance in aws_instance.public_ec3 :
    key => instance.public_ip
  }
}