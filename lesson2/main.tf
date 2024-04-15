resource "aws_vpc" "VPC-bermet" {
    cidr_block = var.vpcCIDR 
}

resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.VPC-bermet.id
    cidr_block = var.subnet1_CIDR
}

resource "aws_subnet" "subnet-2" {
    vpc_id = aws_vpc.VPC-bermet.id
    cidr_block = var.subnet2_CIDR
}

resource "aws_instance" "instance-hw" {
    ami = data.aws_ami.AmazonLinux.id
    instance_type = var.instance-type
    subnet_id = aws_subnet.subnet-2.id
}
