variable "vpc_cidr" {
  default = ""
}

variable "name" {
  default = "Bermet"
}

variable "public_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidrs" {
  default = []
}
