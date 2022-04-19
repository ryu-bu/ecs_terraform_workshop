provider "aws" {
  region  = "us-east-1"
  version = "~> 3.63"
}


terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}