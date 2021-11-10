# VPC Module deploys the following infrastructure
# VPC with defined CIDR
# Internet Gateway to route public subnets directly to the internet
# NAT Gateway (optional) to route private subnets out to the internet
# Public and Private subnets deployed across region AZs
# Public and Private route tables and default rules
# Route table association with public and private subnets

# Create VPC with defined CIDR

resource "aws_vpc" "customer_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

# Create IGW

resource "aws_internet_gateway" "customer_igw" {
  vpc_id = aws_vpc.customer_vpc.id

}

# If require_nat_gateway variable is true then create EIP and NAT Gateway
# Create EIP for NAT Gateway (optional)

resource "aws_eip" "nat" {
  count = var.require_nat_gateway ? 1 : 0

  vpc        = true
  depends_on = [aws_internet_gateway.customer_igw]
}

# If require_nat_gateway variable is true then create EIP and NAT Gateway
# Create EIP for NAT Gateway EC2 Instance (optional)

resource "aws_eip" "nat_gateway_instance" {
  count = var.require_nat_gateway_instance ? 1 : 0

  vpc        = true
  instance = aws_instance.customer_ngw_instance[0].id
  depends_on = [aws_internet_gateway.customer_igw]
}



# Create NAT Gateway (optional)
# Attach EIP and deploy to public subnet (AZa)

resource "aws_nat_gateway" "customer_ngw" {
  count = var.require_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.customer_public_subnet[0].id
}

# Create NAT Gateway Instance (optional)
# Attach EIP and deploy to public subnet (AZa)

resource "aws_instance" "customer_ngw_instance" {
  count = var.require_nat_gateway_instance ? 1 : 0

  ami = "ami-01ae0e01e7fffd105"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.customer_public_subnet[0].id
  source_dest_check = false

  tags = {
    key                 = "Name"
    value               = "NAT gateway"
  }

 
}

# Create public subnets

resource "aws_subnet" "customer_public_subnet" {
  count             = length(var.public_subnet)
  vpc_id            = aws_vpc.customer_vpc.id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = var.deployment_azs[count.index]

  tags = {

    Name = "${var.vpc_name} public subnet ${count.index + 1}"
  }
}

# Create Private subnets

resource "aws_subnet" "customer_private_subnet" {
  count             = length(var.private_subnet)
  vpc_id            = aws_vpc.customer_vpc.id
  cidr_block        = var.private_subnet[count.index]
  availability_zone = var.deployment_azs[count.index]

  tags = {

    Name = "${var.vpc_name} private subnet ${count.index + 1}"
  }
}