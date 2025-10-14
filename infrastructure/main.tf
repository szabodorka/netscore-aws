module "ecr" {
  source = "./modules/ecr"
  project_name = var.project_name
}

module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  region = var.region
}