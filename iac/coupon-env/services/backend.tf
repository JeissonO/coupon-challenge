terraform {
  backend "s3" {
    bucket = "dev-couponpoc-terraform-state-s3"
    key    = "poc/modules/services/terraform.tfstate"
    region = "us-east-1"
  }
}
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket  = module.parameters.backend
    key     = "env:/${terraform.workspace}/poc/modules/networking/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
data "terraform_remote_state" "resources" {
  backend = "s3"
  config = {
    bucket  = module.parameters.backend
    key     = "env:/${terraform.workspace}/poc/modules/resources/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}