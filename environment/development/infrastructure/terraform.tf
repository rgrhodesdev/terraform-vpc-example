terraform {
  
  backend "s3" {

    bucket = "customer-terraform-state-file-rgrhodesdev04"
    key    = "development/infrastructure/terraform.tfstate"
    region = "eu-west-1"

  }
}