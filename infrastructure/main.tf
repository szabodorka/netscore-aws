module "ecr" {
  source = "./modules/ecr"
  project_name = var.project_name
}

module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  region = var.region
}

module "rds" {
  source = "./modules/rds"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = module.vpc.vpc_cidr_block
  subnet_ids = module.vpc.db_subnet_ids
  subnet_cidr_blocks = module.vpc.db_subnet_cidr_blocks
  db_username = var.db_username
  db_password = var.db_password
}