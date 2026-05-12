module "vpc" {
  source               = "../../modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  tags                 = var.tags
}

module "s3" {
  source             = "../../modules/s3"
  project_name       = var.project_name
  environment        = var.environment
  bucket_name        = "" 
  versioning_enabled = false
  tags                 = var.tags
}

module "ec2" {
  source         = "../../modules/ec2"
  project_name   = var.project_name
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnet_ids[0]
  instance_type  = var.instance_type
  instance_count = var.instance_count
  tags           = var.tags
}