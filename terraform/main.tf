module "monitoring" {
  source = "./modules/monitoring"

  region            = "eu-west-3"
  vpc_id            = "vpc-0ca8aacebed836262"
  subnet_id         = "subnet-0b44df42566d7a2e4"
  monitoring_sg_id = "sg-01a09f8c4347acaa3"


}
