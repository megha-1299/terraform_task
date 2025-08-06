
output "vpc_id" {
    value = aws_vpc.my_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public_subnet_a.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet_a.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}

output "ec2_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

output "ec2_instance_id" {
  value = aws_instance.ec2_instance.id
}


