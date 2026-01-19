module "loadbalancer" {
  source = "./modules/loadbalancer"

  vpc_id            = module.networking.vpc_id
  alb_sg_id         = module.networking.alb_sg_id
  public_subnet_ids = [module.networking.public_subnet_id]
}

