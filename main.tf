provider "aws" {
  region = "ap-south-1"
}

variable "availability_zone" {}
variable "vpc_cidr_block" {}
variable "private_subnet_cidr_block" {}
variable "public_subnet_cidr_block" {}
variable "my_ip" {}
variable "public_key_location" {}
variable "instance" {}
variable "env_prefix" {}
variable "ami_image_id" {}
variable "private_key_location" {}
variable "database_name" {}
variable "database_username" {}
variable "database_password" {}




#module "aws_vpc" {
#  source = "./modules/vpc"
#  private_subnets = module.private_subnets.id
#}


