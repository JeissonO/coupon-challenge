locals {
  context_variables = {
    dev = {
      backend              = "dev-couponpoc-terraform-state-s3"
      environment          = "dev"
      organization         = "coupon"
      project              = "poc"
      db_instance_class    = "db.t3.small"
      region_az            = ["us-east-1a", "us-east-1b", "us-east-1c"]
      vpc_cidr_block       = "10.10.0.0/21"
      public_subnet_cidrs  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
      private_subnet_cidrs = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
      allow_cidrs          = [""]
    }
  }
  backend              = lookup(local.context_variables[terraform.workspace], "backend", "poc-terraform-state-s3")
  environment          = lookup(local.context_variables[terraform.workspace], "environment", "dev")
  organization         = lookup(local.context_variables[terraform.workspace], "organization", "coupon")
  project              = lookup(local.context_variables[terraform.workspace], "project", "poc")
  db_instance_class    = lookup(local.context_variables[terraform.workspace], "db_instance_class", "db.t3.small")
  region_az            = lookup(local.context_variables[terraform.workspace], "region_az", ["us-east-1a", "us-east-1b", "us-east-1c"])
  vpc_cidr_block       = lookup(local.context_variables[terraform.workspace], "vpc_cidr_block", "10.0.0.0/16")
  public_subnet_cidrs  = lookup(local.context_variables[terraform.workspace], "public_subnet_cidrs", ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"])
  private_subnet_cidrs = lookup(local.context_variables[terraform.workspace], "private_subnet_cidrs", ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"])
  allow_cidrs          = lookup(local.context_variables[terraform.workspace], "allow_cidrs", [""])
}
