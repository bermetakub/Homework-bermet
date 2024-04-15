variable "vpcCIDR" {
    description = "CIDR block for VPC"
    type = string
}

variable "subnet1_CIDR" {
    description = "CIDR block for first subnet"
    type = string
}

variable "subnet2_CIDR" {
    description = "CIDR block for second subnet"
    type = string
}

variable "instance-type" {
    description = "Type of the instance"
    type = string
    default = "t2.micro"
}