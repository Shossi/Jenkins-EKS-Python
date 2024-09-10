resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = merge(var.tags, { Name = format("%s-vpc", var.vpc_name) })
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(var.public_subnet_tags, {
    Name = format("%s-public-subnet-%d", var.vpc_name, count.index)
  })
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = format("%s-private-subnet-%d", var.vpc_name, count.index)
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = format("%s-igw", var.vpc_name)
  }
}

resource "aws_nat_gateway" "this" {
  count         = length(aws_subnet.public_subnets)
  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = format("%s-nat-gateway-%d", var.vpc_name, count.index)
  }
}

resource "aws_eip" "this" {
  count = length(aws_subnet.public_subnets)
  vpc   = true
  tags  = {
    Name = format("%s-eip-%d", var.vpc_name, count.index)
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = format("%s-public-route-table", var.vpc_name)
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(aws_subnet.private_subnets)
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = {
    Name = format("%s-private-route-table", var.vpc_name)
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}
