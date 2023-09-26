resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count = length(data.aws_availability_zones.available.zone_ids)

  vpc_id = aws_vpc.main.id

  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone_id    = data.aws_availability_zones.available.zone_ids[count.index]
  map_public_ip_on_launch = true
  
  tags                    = {
    Name = join("-", ["public", data.aws_availability_zones.available.zone_ids[count.index]])
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public" {
  count = length(data.aws_availability_zones.available.zone_ids)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
