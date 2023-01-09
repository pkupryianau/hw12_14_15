# ДЗ лабораторная работа № 12
# предварительная версия
terraform {
  required_version = ">= 0.13.1"
required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
  }
}
provider "aws" {
   region = "eu-central-1" # Frankfurt
}
resource "aws_iam_role" "eks-iam-role" {
 name = "eks"
 path = "/"
 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}

EOF
}
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = "aws_iam_role.eks-iam-role.name"
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = "aws_iam_role.eks-iam-role.name"
}
resource "aws_eks_cluster" "cluster-aws_eks" {
  name = "aws_eks_cluster"
  role_arn = aws_iam_role.eks-iam-role.arn
  vpc_config {
    subnet_ids = [var.subnet_id_1, var.subnet_id_2] # network!!!
  }
  depends_on = [
    aws_iam_role.eks-iam-role,
  ]
}
resource "aws_iam_role" "workernode" {
  name = "eks-node-group"
  assume_role_policy = jsonencode({
   Statement = [{
    Action = "sts:AssumeRole"
    Effect = "Allow"
    Principal = {
     Service = "ec2.amazonaws.com"
    }
   }]
   Version = "2012-10-17"
  })
 } 
# https://us-east-1.console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy$serviceLevelSummary
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
   role = aws_iam_role.workernode.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.workernode.name
}
resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role = aws_iam_role.workernode.name
}
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.workernode.name
}
resource "aws_eks_node_group" "workernode-group" {
  cluster_name = aws_eks_cluster.cluster-aws_eks.name
  node_group_name = "aws_eks_workernode"
  node_role_arn = aws_iam_role.workernode.arn
  subnet_ids = [var.subnet_id_1, var.subnet_id_2]
  instance_types = [ "t2.medium" ]   # type of AMI
  scaling_config {
    desired_size = 3
    max_size = 3
    min_size = 3
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
