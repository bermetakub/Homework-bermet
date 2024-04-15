output "VPC_ID" {
  value = aws_vpc.VPC-bermet.id
}

output "VPC_CIDR_block" {
  value = aws_vpc.VPC-bermet.cidr_block
}

output "public-subnet-1_id" {
  value = aws_subnet.public-subnet-1.id
}

output "private-subnet-2_id" {
  value = aws_subnet.private-subnet-2.id
}

output "instance-in-private-subnet" {
  value = aws_instance.instance-in-private-subnet.id
}

output "instance-in-oregon" {
  value = aws_instance.instance-in-oregon.id
}