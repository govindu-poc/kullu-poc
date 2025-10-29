region        = "eu-north-1"
environment   = "stage"
cluster_name  = "poc-eks-cluster"
vpc_cidr      = "10.20.0.0/16"

ami_type       = "AL2_x86_64"
instance_types = ["t3.large"]

desired_size = 3
min_size     = 2
max_size     = 5