terraform {
  backend "s3" {
    bucket = "dev-couponpoc-terraform-state-s3"
    key    = "poc/modules/networking/terraform.tfstate"
    region = "us-east-1"
  }
}
