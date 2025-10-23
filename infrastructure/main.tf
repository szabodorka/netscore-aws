module "ecr" {
  source = "./modules/ecr"
  project_name = var.project_name
}

module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  region = var.region
}

module "vpn" {
  source = "./modules/vpn"
  project_name = var.project_name
  organization_name = var.project_name
  vpc_id = module.vpc.vpc_id
  subnet_ids = {subnet_id: module.vpc.private_subnet_ids[0]}
  nat_subnet_id = module.vpc.private_subnet_ids[0]
  vpn_domain = "vpn.${var.project_name}.com"
  clients = var.vpn_clients
}
