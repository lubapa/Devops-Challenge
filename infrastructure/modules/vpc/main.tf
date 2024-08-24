resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}:csgtest"
  }
}

resource "aws_subnet" "container" {
  count                   = length(var.container_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.container_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(var.azs, count.index)
  tags = {
    Name = "${var.name}-public-${count.index}:csgtest"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "${var.name}-private-${count.index}:csgtest"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.name}-igw:csgtest"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.name}-public-rt:csgtest"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.container_subnet_cidrs)
  subnet_id      = aws_subnet.container[count.index].id
  route_table_id = aws_route_table.public.id
}
