output "cluster_name" {
  value = var.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_oidc" {
  value = module.eks.oidc_provider_arn
}

output "kubeconfig_file" {
  value = "kubeconfig_${var.cluster_name}"
}
