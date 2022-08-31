module "networking" {
  source        = "./networking"
  vpc_cidr      = "10.0.0.0/16"
  access_ip     = var.access_ip
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

module "ec2" {
  source         = "./ec2"
  public_sg      = module.networking.public_sg
  private_sg     = module.networking.private_sg
  private_subnet = module.networking.private_subnet
  public_subnet  = module.networking.public_subnet
  elb            = module.load_balancer.elb
  alb_tg         = module.load_balancer.alb_tg
  key_name       = "KP_project23"
}

module "load_balancer" {
  source         = "./load_balancer"
  public_subnet = module.networking.public_subnet
  vpc_id         = module.networking.vpc_id
  web_sg         = module.networking.web_sg
  database_asg   = module.ec2.database_asg
}
