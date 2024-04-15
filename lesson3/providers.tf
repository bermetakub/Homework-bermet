provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "oregon"
  region = "us-west-2"
}