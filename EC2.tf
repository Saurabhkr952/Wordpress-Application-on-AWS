# first we create "ssh security group"
# Then update "Webserver" and "EFS security group" and add "ssh security group source"
# Source means we can access from there

resource "aws_key_pair" "ssh_key" {
  key_name = "webserver-ssh-key"
  public_key = file(var.public_key_location)
}


resource "aws_instance" "wordpress_server" {
  ami = var.ami_image_id
  instance_type = var.instance
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.ssh_security_group.id, aws_security_group.alb_security_group.id, aws_security_group.webserver_security_group.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh_key.key_name

 # user_data = file("entry-script.sh")

  tags = {
    "Name" = "setup-server"
  }
}


#resource "aws_instance" "webserver1" {
#  ami = var.ami_image_id
#  instance_type = var.instance
#  subnet_id = module.vpc.private_subnets[1]
#  vpc_security_group_ids = [aws_security_group.webserver_security_group.id]
#  #associate_public_ip_address = false
#  key_name = aws_key_pair.ssh_key.key_name
#
#  tags = {
#    "Name" = "webs_server_1a"
#  }
#}
#
#
#resource "aws_instance" "webserver2" {
#  ami = var.ami_image_id
#  instance_type = var.instance
#  subnet_id = module.vpc.private_subnets[2]
#  vpc_security_group_ids = [aws_security_group.webserver_security_group.id]
##  associate_public_ip_address = false
#  key_name = aws_key_pair.ssh_key.key_name
#
#  tags = {
#    "Name" = "web_server_1b"
#  }
#}
#

# provisioner to execute ansible playbook
resource "null_resource" "configure_server"{

depends_on = [aws_instance.wordpress_server,aws_efs_file_system.my_app_efs,aws_efs_mount_target.one_azs,module.db,] # aws_instance.webserver1,aws_instance.webserver2
connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_location)
    host        = aws_instance.wordpress_server.public_ip
    timeout     = "20s"
  }

provisioner "local-exec"{
  command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ec2-user --private-key  ${var.private_key_location} -i ${aws_instance.wordpress_server.public_ip}, playbook.yaml --extra-vars \"file_system_dns=${aws_efs_file_system.my_app_efs.dns_name}\""
  }
}
#command = "ansible-playbook  -i ${aws_instance.wordpress_server.public_ip}, --private-key ${var.private_key_location} nginx.yaml"

