resource "aws_security_group" "ssh_security_group" {
  name = "SSH_security_group"
  vpc_id = module.vpc.vpc_id

  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  
  tags = {
    "Name" = "ssh-sg"
  } 
}


resource "aws_security_group" "alb_security_group" {
  name        = "alb_security_group" # Security group name 
  description = "ALB Security Group"
  vpc_id = module.vpc.vpc_id
  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "ALB Security Group"
  }
}

resource "aws_security_group" "webserver_security_group" {
  name = "Webserver Security Group"
  description = "Webserver Security Group"
  vpc_id = module.vpc.vpc_id
  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
 #  cidr_blocks = [aws_security_group.alb_security_group.security_groups]
    security_groups = [aws_security_group.alb_security_group.id] # in place of CIDR blocks,security groups is used   [The following arguments are optional:]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp" 
    security_groups = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

   ingress {                                                                   # while deploying 
    description = "SSH "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.ssh_security_group.id]
  }

  tags = {
    Name = "Webserver Security Group"
  }

}

resource "aws_security_group" "database_security_group" {
  name = "Database Security Group"
  description = "Database Security Group"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.webserver_security_group.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "MYSQL database"
  }

}

resource "aws_security_group" "efs_security_group" {
  name = "EFS Security Group"
  description = "EFS Security Group"
  vpc_id = module.vpc.vpc_id

  ingress {                                   
    description = "EFS Security Group"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [aws_security_group.webserver_security_group.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  ingress {                                                                   # while deploying 
    description = "SSH "
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.ssh_security_group.id]
  }

  tags = {
    Name = "Security Group for EFS"
  }

}

resource "aws_security_group_rule" "efs_security_group" {
  description              = "Allow outbound EFS traffic"
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.efs_security_group.id
  security_group_id        = aws_security_group.efs_security_group.id
}