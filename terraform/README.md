# EKS Terraform Ready Project (Windows / PowerShell)
This package contains:
- PowerShell helper scripts to create S3 + DynamoDB backend, run Terraform init/plan/apply, update kubeconfig, and deploy the microservices demo.
- Terraform files for creating a VPC + EKS cluster using terraform-aws-modules/eks/aws.
- A simple deploy script to apply the Sock Shop manifests.

**How to use**
1. Unzip the package.
2. Edit `backend.tf` to set your unique S3 bucket name and DynamoDB table name OR set environment variables as described below.
3. Run `.-create-backend.ps1` to create the S3 bucket and DynamoDB table (optional if you already created them).
4. Run `.-terraform-init-apply.ps1` to initialize and apply Terraform (will prompt for confirmation).
5. After Terraform finishes, run `.-update-kubeconfig-and-deploy.ps1` to update kubeconfig and deploy the microservices demo.

**Environment variables supported**
- AWS_PROFILE (optional) - AWS CLI profile to use
- AWS_REGION (defaults to eu-north-1)
- TF_STATE_BUCKET - bucket name for terraform state
- TF_LOCK_TABLE - DynamoDB table name for locks
- CLUSTER_NAME - EKS cluster name

**Notes**
- This is provided as a convenience to get you started quickly. Review all files before running in your account.
- Running Terraform will create AWS resources and may incur charges. Destroy the stack when finished: `terraform destroy`.
