locals {
  ingress_ports = [22, 80, 443]
}

module "networking" {
  source        = "../../modules/networking"
  vpc_cidr      = "10.0.0.0/16"
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

}

module "asg" {
  source = "../../modules/asg"

  name_prefix    = "bermet-hw"
  instance_type  = "t2.micro"
  desired_size   = 2
  max_size       = 3
  min_size       = 1
  private_subnet = [module.networking.privates["10.0.3.0/24"], module.networking.privates["10.0.4.0/24"]]
  sg             = [aws_security_group.sg.id]
  tg             = [module.alb.target_group_arn]
}

module "alb" {
  source   = "../../modules/alb"
  alb_name = "alb-bermet-hw"
  sg       = [aws_security_group.sg.id]
  subnets  = [module.networking.publics["10.0.1.0/24"], module.networking.publics["10.0.2.0/24"]]
  vpc      = module.networking.vpc_id
  sgroup   = [aws_security_group.sg.id]
}

resource "aws_security_group" "sg" {
  vpc_id = module.networking.vpc_id
  dynamic "ingress" {
    for_each = toset(local.ingress_ports)
    content {
      to_port     = ingress.key
      from_port   = ingress.key
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "tcp"
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}