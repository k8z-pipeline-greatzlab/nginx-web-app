resource "aws_lb" "this" {
  count = length(var.instance_name) == 0 ? 0 : 1

  name               = "test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_ec3_sg[count.index].id]
  subnets            = slice(data.aws_subnets.available.ids, 0, 3)

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
  vpc_id      = var.vpc_id
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
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[count.index].arn
  }
  depends_on = [aws_instance.public_ec3]
}

###########
# EC2 Instance
###########
resource "aws_instance" "public_ec3" {
  for_each      = var.instance_name
  ami           = each.value["image"]
  instance_type = each.value["type"]
  subnet_id     = data.aws_subnets.available.ids[0]
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


###########
# Security Group
###########
resource "aws_security_group" "public_ec3_sg" {
  count = length(var.instance_name) == 0 ? 0 : 1
  
  name        = "gitops_ansilble_sg"
  description = "GitOps LAB sg"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "gitops_ansilble_sg"
  }
}
