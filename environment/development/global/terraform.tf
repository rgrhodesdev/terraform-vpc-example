terraform {
  
  backend "s3" {

    bucket = "customer-terraform-state-file-rgrhodesdev04"
    key    = "global/s3/terraform.tfstate"
    region = "eu-west-1"

  }
}