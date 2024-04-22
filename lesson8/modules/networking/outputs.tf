output "publics" {
  value = { for i, v in aws_subnet.public_subnet : i => v.id }
}

output "privates" {
  value = { for i, v in aws_subnet.private_subnet : i => v.id }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_azs" {
  value = { for subnet_id, subnet in aws_subnet.public_subnet : subnet_id => subnet.availability_zone }
}