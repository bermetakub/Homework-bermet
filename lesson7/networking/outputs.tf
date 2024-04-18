output "subnet" {
  value = {
    for key, subnet in aws_subnet.public-subnets :
    key => subnet.id
  }
}
output "vpc" {
  value = aws_vpc.vpc.id
}