data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, 2 + count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.name_prefix}-private-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

resource "aws_route_table" "public" {
  count  = 2
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
}