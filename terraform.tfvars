availability_zone = ["ap-south-1a", "ap-south-1b"]
vpc_cidr_block = "10.0.0.0/16"

public_subnet_cidr_block = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidr_block = ["10.0.4.0/24", "10.0.6.0/24","10.0.5.0/24","10.0.7.0/24"]
                        #     ap south 1a ,        1b    ,      1a    ,       1b
                        #                                   database    , database 
                                                                
  
my_ip = "122.50.198.223/32"                 
instance = "t2.micro"
env_prefix = "dev"  
ami_image_id = "ami-0e6329e222e662a52"
public_key_location = "/root/.ssh/id_rsa.pub"     
private_key_location = "/root/.ssh/id_rsa" 
# database
database_name  = "demodb"
database_username = "user"
database_password = "QxMCi6rO7T10HybO"
