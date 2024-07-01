output "cluster_id" {
  value = module.eks_cluster.cluster_id
}

output "cluster_name" {
  value = module.eks_cluster.cluster_name
}

output "kubeconfig" {
  value = module.eks_cluster.kubeconfig_filename
}

