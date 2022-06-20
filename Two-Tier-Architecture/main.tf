provider "aws" {
  region = var.main_region
}

module "vpc" {
  source = "./modules"
  region = var.main_region
}

resource "aws_instance" "two-tier-instance1" {
  ami           = module.vpc.ami_id
  subnet_id     = module.vpc.subnet_id1
  instance_type = "t2.micro"
}

resource "aws_instance" "two-tier-instance2" {
  ami           = module.vpc.ami_id
  subnet_id     = module.vpc.subnet_id2
  instance_type = "t2.micro"
}

resource "aws_db_instance" "two_tier_db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "two_tier_db"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.two_tier_db.name
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "two_tier_db" {
  name       = "two_tier_db"
  subnet_ids = [module.vpc.subnet_id3, module.vpc.subnet_id4]

  tags = {
    Name = "two_tier_db"
  }
}