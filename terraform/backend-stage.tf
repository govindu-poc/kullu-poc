terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "kullu-eks-tf-state"
    key            = "eks/stage/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "kullu-eks-tf-lock"
    encrypt        = true
  }
}