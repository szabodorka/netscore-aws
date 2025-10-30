provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
  registry_config_path   = "${path.root}/.helm/registry.json"
  repository_cache       = "${path.root}/.helm/cache"
  repository_config_path = "${path.root}/.helm/repositories.yaml"
}