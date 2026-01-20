module "networking" {
  source = "./modules/networking"

  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name

  public_subnet_cidrs = var.public_subnet_cidrs
  public_subnet_azs   = var.public_subnet_azs
  public_subnet_names = var.public_subnet_names

  private_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_azs   = var.private_subnet_azs
  private_subnet_names = var.private_subnet_names

  monitoring_allowed_cidr = var.monitoring_allowed_cidr
  allowed_ssh_cidr        = var.allowed_ssh_cidr
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  name              = var.name
  vpc_id            = module.networking.vpc_id
  alb_sg_id         = module.networking.alb_sg_id
  public_subnet_ids = module.networking.public_subnet_ids

  target_port       = var.target_port
  health_check_path = var.health_check_path
}

module "autoscaling" {
  source = "./modules/autoscaling"

  name          = var.name
  ami_id        = var.ami_id
  instance_type = var.instance_type

  ec2_sg_id  = module.networking.ec2_sg_id
  subnet_ids = module.networking.public_subnet_ids

  target_group_arn = module.loadbalancer.target_group_arn

  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  user_data        = var.user_data
}
