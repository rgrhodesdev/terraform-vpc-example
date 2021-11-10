data "terraform_remote_state" "vpc" {

    backend = "s3"

    config = {
        bucket = "customer-terraform-state-file-rgrhodesdev04"
        key    = "development/infrastructure/terraform.tfstate"
        region = "eu-west-1"
    }


}