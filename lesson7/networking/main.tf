provider "aws" {
  region = "us-east-1" 
}
locals {
  public_subnets = {
    Public1 = "10.0.1.0/24"
    Public2 = "10.0.2.0/24"
    Public3 = "10.0.3.0/24"
  }
  private_subnets = {
    Private1 = "10.0.4.0/24"
    Private2 = "10.0.5.0/24"
    Private3 = "10.0.6.0/24"
}
}
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "vpc"
  }
}
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.vpc.id 
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "rt_association" {
    for_each = aws_subnet.public-subnets
    subnet_id = each.value.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "public-subnets" {
  vpc_id   = aws_vpc.vpc.id
  for_each = local.public_subnets
  cidr_block = each.value
  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id   = aws_vpc.vpc.id
  for_each = local.private_subnets
  cidr_block = each.value
  tags = {
    Name = each.key
  }
}