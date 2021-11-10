# Create Public Route Table

resource "aws_route_table" "customer_public_rt" {
  #count                   = length(var.public_subnet)
  vpc_id = aws_vpc.customer_vpc.id

  tags = {
    #Name = "${var.vpc_name} public RT ${count.index+1}"
    Name = "${var.vpc_name} public RT"
  }

}

# Create Private Route Table

resource "aws_route_table" "customer_private_rt" {

  vpc_id = aws_vpc.customer_vpc.id

  tags = {
    Name = "${var.vpc_name} private RT"
  }

}

# Associate all public subnets with the public route table

resource "aws_route_table_association" "customer_public_rt_assoc" {
  count = length(var.public_subnet)

  route_table_id = aws_route_table.customer_public_rt.id
  subnet_id      = aws_subnet.customer_public_subnet[count.index].id

}

# Associate all private subnets with the private route table

resource "aws_route_table_association" "customer_private_rt_assoc" {
  count = length(var.private_subnet)

  route_table_id = aws_route_table.customer_private_rt.id
  subnet_id      = aws_subnet.customer_private_subnet[count.index].id

}

# Public Route Table Rules For all public subnets

resource "aws_route" "customer_public_rt_default_route" {
  route_table_id         = aws_route_table.customer_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.customer_igw.id
}

# Private Route Table Rules For all private subnets

# The following default rule to the NAT gatway will only be created if require_nat_gateway = true

resource "aws_route" "customer_private_rt_a_default_route" {
  count = var.require_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.customer_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.customer_ngw[count.index].id
}

resource "aws_route" "customer_private_rt_a_default_route_nat_instance" {
  count = var.require_nat_gateway_instance ? 1 : 0

  route_table_id         = aws_route_table.customer_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  instance_id         = aws_instance.customer_ngw_instance[0].id
}