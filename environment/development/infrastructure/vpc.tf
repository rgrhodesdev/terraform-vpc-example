module "environment_vpc" {
    source ="../../../modules/infrastructure"

    vpc_name = "development"
    vpc_cidr = "10.1.0.0/16"

    deployment_azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    public_subnet = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    private_subnet = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]

    require_nat_gateway = false
    require_nat_gateway_instance = false

}