resource "aws_efs_file_system" "my_app_efs" {
  creation_token = "My Application EFS"

  tags = {
    Name = "My Application EFS"
  }
}

resource "aws_efs_mount_target" "one_azs" {
#  availability_zone_id = module.vpc.azs[0]
  file_system_id = aws_efs_file_system.my_app_efs.id
  subnet_id      = module.vpc.private_subnets[2]
  security_groups = [aws_security_group.efs_security_group.id] 
}


resource "aws_efs_mount_target" "two_azs" {

  file_system_id = aws_efs_file_system.my_app_efs.id
  subnet_id      = module.vpc.private_subnets[3]
  security_groups = [aws_security_group.efs_security_group.id]
}


