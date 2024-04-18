terraform {
  backend "s3" {
    bucket = "terraform.tfstate-networking"
    key = "networking/terraform.tfstate" 
    region = "us-east-1"  
  }
}