variable "cidr_block" {
    type = string
    description = "cidr block for vpc"
}

variable "vpc_name" {
    type = string
    description = "Name of the vpc"
}

variable "public_subnet_a_cidr" {
  type        = string
  description = "CIDR for Public Subnet A"
}

# variable "public_subnet_b_cidr" {
#   type        = string
#   description = "CIDR for Public Subnet B"
# }

variable "private_subnet_a_cidr" {
  type        = string
  description = "CIDR for Private Subnet A"
}

# variable "private_subnet_b_cidr" {
#   type        = string
#   description = "CIDR for Private Subnet B"
# }

variable "key_name" {
  type        = string
  description = "Name of the key pair"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for EC2 instance"
}

