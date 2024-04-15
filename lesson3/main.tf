resource "aws_vpc" "VPC-bermet" {
    cidr_block = var.vpcCIDR 
}

resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.VPC-bermet.id
    cidr_block = var.subnet1_CIDR
    map_public_ip_on_launch = true
    depends_on = [ aws_internet_gateway.IGW ]
}

resource "aws_subnet" "private-subnet-2" {
    vpc_id = aws_vpc.VPC-bermet.id
    cidr_block = var.subnet2_CIDR
    depends_on = [ aws_vpc.VPC-bermet ]
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.VPC-bermet.id
  
  # Allow HTTP, HTTPS, SSH from the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.VPC-bermet.id
}

resource "aws_eip" "ElasticIP" {
}

resource "aws_nat_gateway" "NAT-gateway" {
    subnet_id = aws_subnet.private-subnet-2.id
    allocation_id = aws_eip.ElasticIP.allocation_id
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.VPC-bermet.id
}

resource "aws_route_table_association" "public-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route" "route_public_subnet" {
  route_table_id            = aws_route_table.public_route_table.id
  gateway_id = aws_internet_gateway.IGW.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.VPC-bermet.id
}

resource "aws_route_table_association" "private-route-table-association" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route" "route_private_subnet" {
  route_table_id            = aws_route_table.private_route_table.id
  nat_gateway_id = aws_nat_gateway.NAT-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_instance" "instance-in-private-subnet" {
    ami = data.aws_ami.AmazonLinux.id
    instance_type = var.instance-type
    subnet_id = aws_subnet.private-subnet-2.id
    depends_on = [ aws_subnet.private-subnet-2 ]
}

resource "aws_instance" "instance-in-oregon" {
    ami = data.aws_ami.AmazonLinux-oregon.id
    instance_type = var.instance-type
    provider = aws.oregon
    depends_on = [ aws_instance.instance-in-private-subnet ]
}
#end