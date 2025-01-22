module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  environment        = var.environment
  region            = var.aws_region
}

module "ec2" {
  source = "../../modules/ec2"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  subnet_id   = module.vpc.public_subnet_id
  ami_id      = "ami-0440d3b780d96b29d"  # Update with latest Amazon Linux 2 AMI
}