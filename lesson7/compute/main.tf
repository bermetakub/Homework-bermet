locals {
  security_group = {
    first_sg = [22]
    second_sg = [80]
    third_sg = [22, 80, 443]
  }
  instances = {
    first = {
      associate_public_ip_address = true
      subnet_id = values(data.terraform_remote_state.networking.outputs.subnet)[0]
    }
    second = {
      associate_public_ip_address = true
      subnet_id = values(data.terraform_remote_state.networking.outputs.subnet)[1]
    }
    third = {
    }
  }
  Name = "Bermet"
  }

resource "aws_security_group" "sg" {
    for_each = local.security_group
    name = each.key
    vpc_id = data.terraform_remote_state.networking.outputs.vpc
    dynamic "ingress" {
      # for_each = local.security_group
      #for_each = each.value == local.security_group.third_sg ? local.security_group.third_sg : []
      for_each = each.value
      content {
       from_port = ingress.value
       to_port = ingress.value
       cidr_blocks = ["0.0.0.0/0"]
       protocol = "tcp"
      }
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = each.key
  }
}

resource "aws_instance" "instance" {
  #for_each = data.terraform_remote_state.networking.outputs.subnet
  for_each = local.instances
  #count           = length(data.terraform_remote_state.networking.outputs.subnet)
  ami             = data.aws_ami.AmazonLinux.id
  instance_type   = "t2.micro"
  associate_public_ip_address = lookup(each.value, "associate_public_ip_address", false)
  #subnet_id       = data.terraform_remote_state.networking.outputs.subnet[count.index]
  #security_groups = [values(aws_security_group.sg)[count.index].id]
  
  subnet_id       = lookup(each.value, "subnet_id",  values(data.terraform_remote_state.networking.outputs.subnet)[2])
  vpc_security_group_ids = [ each.key == "first" ? aws_security_group.sg["first_sg"].id : each.key == "second" ? aws_security_group.sg["second_sg"].id : aws_security_group.sg["third_sg"].id]
  #security_groups = element(aws_security_group.sg.id, count.index)
  #vpc_security_group_ids = [data.terraform_remote_state.networking.outputs.subnet == "Public1" ? aws_security_group.sg["first_sg"].id : data.terraform_remote_state.networking.outputs.subnet == "Public2" ? aws_security_group.sg["second_sg"].id : aws_security_group.sg["third_sg"].id ]
  #security_groups =  [values(aws_security_group.sg)[count.index].id]
  #security_groups = [local.instances == "first" ? aws_security_group.sg.id[0] : local.instances == "second" ? aws_security_group.sg.id[1] : aws_security_group.sg.id[2]]
  #security_groups = [data.terraform_remote_state.networking.outputs.subnet == "Public1" ?  aws_security_group.sg.id[0] : data.terraform_remote_state.networking.outputs.subnet == "Public2" ? aws_security_group.sg.id[1] : aws_security_group.sg.id[2]]
    # for_each = local.instances
    # ami = data.aws_ami.AmazonLinux.id
    # instance_type = "t2.micro"
    # subnet_id = lookup(for data.terraform_remote_state.networking.outputs.subnet)
  depends_on = [ aws_security_group.sg ]
  tags = {
    "instance" = each.key
  }
}
