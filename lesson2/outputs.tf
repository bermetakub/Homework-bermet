output "VPC_ID" {
  value = aws_vpc.VPC-bermet.id
}

output "VPC_CIDR_block" {
    value = aws_vpc.VPC-bermet.cidr_block
}

output "subnet1_id" {
    value = aws_subnet.subnet-1.id
}

output "subnet2_id" {
    value = aws_subnet.subnet-2.id
}

output "instanceID" {
    value = aws_instance.instance-hw.id
}
