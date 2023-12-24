resource "aws_lb" "this" {
  count = length(var.instance_name) == 0 ? 0 : 1

  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_ec3_sg[count.index].id]
  subnets            = ["subnet-0d8239bfc96aef6a1","subnet-0e91c4feae44e6cf0","subnet-02f1036885eca1c71"]#[for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

  
  depends_on = [aws_instance.public_ec3]

  tags = {
    Environment = "GitOps"
  }
}

resource "aws_lb_target_group" "this" {
  count = length(var.instance_name) == 0 ? 0 : 1

  name        = "nginx-tg"
  port        = 80
  protocol    = "HTTP"
  #target_type = "ip"
  vpc_id      = "vpc-0ec8067849557d0f8"
  depends_on = [aws_instance.public_ec3]
}

locals {
  instance_ids = {
    for k, v in aws_instance.public_ec3 :
    k => v.id
  }
}

resource "aws_lb_target_group_attachment" "this" {
  for_each = local.instance_ids

  # covert a list of instance objects to a map with instance ID as the key, and an instance
  # object as the value.
#   for_each = {
#     for k, v in aws_instance.public_ec3 :
#     v.id => v
#   }

  target_group_arn = aws_lb_target_group.this[0].arn
  target_id        = each.value
  port             = 80

  depends_on = [aws_instance.public_ec3]
}

resource "aws_lb_listener" "this" {
  count = length(var.instance_name) == 0 ? 0 : 1

  load_balancer_arn = aws_lb.this[count.index].arn
  port              = "80"
  protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[count.index].arn
  }
  depends_on = [aws_instance.public_ec3]
}