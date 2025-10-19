terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "poc-eks-tf-state"  # <- REPLACE me or set TF_STATE_BUCKET env var
    key            = "eks/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "poc-eks-tf-lock"                       # <- REPLACE me or set TF_LOCK_TABLE env var
    encrypt        = true
  }
}
