#module "alb" {
#  source  = "terraform-aws-modules/alb/aws"
#  version = "~> 8.0"
#
#  name = "my-alb"
#
#  load_balancer_type = "application"
#
#  vpc_id             = var.vpc_cidr_block 
#  subnets            = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
#  security_groups    = [aws_security_group.alb_security_group.id]
#
#  access_logs = {
#    bucket = "my-alb-logs"
#  }
#
#  target_groups = [
#    {
#      name_prefix      = "pref-"
#      backend_protocol = "HTTP"
#      backend_port     = 80
#      target_type      = "instance"
#      targets = {
#        my_target = {
#          target_id = aws_instance.webserver1.id
#          port = 80
#        }
#        my_other_target = {
#          target_id = aws_instance.webserver2.id
#          port = 80
#        }
#      }
#    }
#  ]
#
#
#  tags = {
#    Environment = "Test"
#  }
#}