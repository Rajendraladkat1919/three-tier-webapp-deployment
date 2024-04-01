terraform {
  backend "s3" {
    bucket = "rala-demo"
    key    = "eks/terraform.tfstate"
    region = "eu-central-1"
  }
}


