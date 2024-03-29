#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "eks-node" {
  name = "terraform-eks-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonRoute53ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-AmazonRoute53AutoNamingRegistrantAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53AutoNamingRegistrantAccess"
  role       = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "eks-node-CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks-node.name
}

resource "aws_eks_node_group" "eks" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks"
  node_role_arn   = aws_iam_role.eks-node.arn
  subnet_ids      = aws_subnet.eks_subnet[*].id
  instance_types  = var.instance_type

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-node-AmazonRoute53ReadOnlyAccess,
    aws_iam_role_policy_attachment.eks-node-AmazonRoute53AutoNamingRegistrantAccess,
  ]
}
