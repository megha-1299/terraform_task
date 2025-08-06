
#Create vpc
resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    
    tags = {
        Name = var.vpc_name
    }
}

# Public Subnet 1 (AZ a)
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-Public-Subnet-A"
  }
}

# Public Subnet 2 (AZ b)
# resource "aws_subnet" "public_subnet_b" {
#   vpc_id                  = aws_vpc.my_vpc.id
#   cidr_block              = var.public_subnet_b_cidr
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "${var.vpc_name}-Public-Subnet-B"
#   }
# }

# Private Subnet 1 (AZ a)
resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_a_cidr
  
  tags = {
    Name = "${var.vpc_name}-Private-Subnet-A"
  }
}

# Private Subnet 2 (AZ b)
# resource "aws_subnet" "private_subnet_b" {
#   vpc_id            = aws_vpc.my_vpc.id
#   cidr_block        = var.private_subnet_b_cidr

#   tags = {
#     Name = "${var.vpc_name}-Private-Subnet-B"
#   }
# }

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.vpc_name}-Public-RT"
  }
}

# Public Route: IGW ke through internet access
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnet A
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}

# ---------------------------
# Private Route Table (Future NAT ke liye)
# ---------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.vpc_name}-Private-RT"
  }
}

# Associate Private Subnet A
resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_rt.id
}

# ---------------------------
# Security Group for Public EC2
# ---------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "${var.vpc_name}-EC2-SG"
  description = "Allow HTTP, HTTPS, SSH inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  # Inbound Rules
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules (Allow all)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-EC2-SG"
  }
}

# ---------------------------
# Security Group for RDS MySQL
# ---------------------------
resource "aws_security_group" "rds_sg" {
  name        = "${var.vpc_name}-RDS-SG"
  description = "Allow MySQL inbound traffic from EC2 SG"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "Allow MySQL from EC2 SG"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-RDS-SG"
  }
}

# ---------------------------
# Key Pair (Existing or New)
# ---------------------------

# ---------------------------
# EC2 Instance in Public Subnet
# ---------------------------
resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet_a.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "${var.vpc_name}-EC2"
  }
}

