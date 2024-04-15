locals {
  instance_type = "t2.micro"

  instances = ["first-instance", "second-instance"]

}

resource "aws_instance" "instance" {
  
  count = length(local.instances)

  ami = data.aws_ami.AmazonLinux.id
  instance_type = local.instance_type

  tags = {
    Name = local.instances[count.index]
  }
}