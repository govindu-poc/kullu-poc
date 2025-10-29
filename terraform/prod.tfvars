region        = "eu-north-1"
environment   = "prod"
cluster_name  = "poc-eks-cluster"
vpc_cidr      = "10.30.0.0/16"

ami_type       = "AL2_x86_64"
instance_types = ["m4.xlarge"]

desired_size = 4
min_size     = 3
max_size     = 8