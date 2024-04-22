output "alb_dns_name" {
  value = module.alb.dns_name
}
output "public_subnets" {
  value = module.networking.publics
}

output "private_subnets" {
  value = module.networking.privates
}

output "arn_asg" {
  value = module.asg.asg_arn
}

output "az" {
  value = module.networking.subnet_azs
}