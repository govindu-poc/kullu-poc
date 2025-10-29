region        = "eu-north-1"
environment   = "dev"
cluster_name  = "poc-eks-cluster"
vpc_cidr      = "10.10.0.0/16"

ami_type       = "AL2_x86_64"
instance_types = ["t3.medium"]

desired_size = 2
min_size     = 1
max_size     = 3