module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name            = "My-Dev-VPC"
  cidr            = var.vpc_cidr_block
  azs             = var.availability_zone
  private_subnets = var.private_subnet_cidr_block
  public_subnets  = var.public_subnet_cidr_block

  enable_nat_gateway = true
  single_nat_gateway  = false
  one_nat_gateway_per_az = true
  
  # for database 
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
