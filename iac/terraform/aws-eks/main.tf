module "eks" {
  source  = "../../../gits/terraform-aws-eks"
  #version = "~> 18.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.24"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  vpc_id     = "vpc-09152dc38707385f0"
  subnet_ids = ["subnet-0b6a13f3df00b7e1b", "subnet-0e330f8be42d2b737", "subnet-00077c78422d0a507"]

  eks_managed_node_group_defaults = {
    disk_size      = 60
    instance_types = ["t3a.large"]
  }

  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = false

  #aws_auth_roles = [
  #  {
  #    rolearn  = "arn:aws:iam::66666666666:role/role1"
  #    username = "role1"
  #    groups   = ["system:masters"]
  #  },
  #]

  #aws_auth_users = [
  #  {
  #    userarn  = "arn:aws:iam::66666666666:user/user1"
  #    username = "user1"
  #    groups   = ["system:masters"]
  #  },
  #  {
  #    userarn  = "arn:aws:iam::66666666666:user/user2"
  #    username = "user2"
  #    groups   = ["system:masters"]
  #  },
  #]

  #aws_auth_accounts = [
  #  "777777777777",
  #  "888888888888",
  #]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
