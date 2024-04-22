locals {
  public_cidrs = {
    "10.0.1.0/24" = {
      azs = "us-east-1a"
    }
    "10.0.2.0/24" = {}
  }
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    "Name" = "${var.name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each                = local.public_cidrs
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.key
  map_public_ip_on_launch = true
  availability_zone       = lookup(each.value, "azs", "us-east-1b")
  tags = {
    "Name" = "${var.name}-public-subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  tags = {
    "Name" = "${var.name}-igw"
  }
}

resource "aws_internet_gateway_attachment" "igw-attach" {
  internet_gateway_id = aws_internet_gateway.igw.id
  vpc_id              = aws_vpc.vpc.id
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public-rt-associate" {
  for_each       = toset(var.public_cidrs)
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public_subnet[each.value].id
}

resource "aws_subnet" "private_subnet" {
  for_each = toset(var.private_cidrs)

  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.key
  tags = {
    "Name" = "${var.name}-private-subnet-${each.key}"
  }
}

resource "aws_eip" "private" {
  tags = {
    "Name" = "${var.name}-eip"
  }
}

resource "aws_nat_gateway" "NAT" {
  subnet_id     = aws_subnet.public_subnet["10.0.1.0/24"].id
  allocation_id = aws_eip.private.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
}

resource "aws_route_table_association" "private-rt-associate" {
  for_each       = toset(var.private_cidrs)
  route_table_id = aws_route_table.private-rt.id
  subnet_id      = aws_subnet.private_subnet[each.key].id
}