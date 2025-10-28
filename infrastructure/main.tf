module "ecr" {
  source             = "./modules/ecr"
  project_name       = var.project_name
}

module "vpc" {
  source             = "./modules/vpc"
  project_name       = var.project_name
  region             = var.region
}

module "eks" {
  source             = "./modules/eks"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  project_name       = var.project_name
  region             = var.region
  cluster_name       = "${var.project_name}-eks-cluster"
}

module "vpn" {
  source             = "./modules/vpn"
  project_name       = var.project_name
  organization_name  = var.project_name
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = {subnet_id: module.vpc.private_subnet_ids[0]}
  nat_subnet_id      = module.vpc.private_subnet_ids[0]
  vpn_domain         = "vpn.${var.project_name}.com"
  clients            = var.vpn_clients
}
module "rds" {
  source             = "./modules/rds"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = module.vpc.vpc_cidr_block
  subnet_ids         = module.vpc.db_subnet_ids
  subnet_cidr_blocks = module.vpc.db_subnet_cidr_blocks
  db_username        = var.db_username
  db_password        = var.db_password
}
