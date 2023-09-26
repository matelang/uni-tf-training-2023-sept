# resource_type.resource_identifier
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = var.name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id               = aws_vpc.main.id
  cidr_block           = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone_id = var.azs[count.index]

  tags = {
    Name = join("-", ["public", var.azs[count.index]])
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.azs)

  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public[count.index].id
}
