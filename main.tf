provider "aws" {
    region = "ap-south-1"
}

module "vpc" {
    source = "./modules/vpc"
    cidr_block = "10.0.0.0/16"
    vpc_name = "My_terraform_vpc"
    public_subnet_a_cidr = "10.0.1.0/24"
   # public_subnet_b_cidr = "10.0.2.0/24"
    private_subnet_a_cidr = "10.0.3.0/24"
   # private_subnet_b_cidr = "10.0.4.0/24"

   # EC2 Config
  key_name         = "demo-key"
  # Path to your public key
  ami_id           = "ami-0f918f7e67a3323f0" # Example Amazon Linux 2 AMI (ap-south-1)
  instance_type    = "t2.micro"
}

output "created_vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  value = module.vpc.private_route_table_id
}

output "ec2_security_group_id" {
  value = module.vpc.ec2_security_group_id
}

output "rds_security_group_id" {
  value = module.vpc.rds_security_group_id
}

terraform {
  backend "s3" {
    bucket = "megha8566"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}




output "ec2_public_ip" {
  value = module.vpc.ec2_public_ip
}

