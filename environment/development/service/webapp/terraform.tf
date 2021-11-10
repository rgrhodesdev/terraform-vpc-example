terraform {
  
  backend "s3" {

    bucket = "customer-terraform-state-file-rgrhodesdev04"
    key    = "development/service/webapp/terraform.tfstate"
    region = "eu-west-1"

  }
}