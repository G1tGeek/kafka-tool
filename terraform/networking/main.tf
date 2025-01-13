################### Fetch Default VPC Details ###################

data "aws_vpc" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

################### VPC ###################

resource "aws_vpc" "tool" {
  cidr_block       = var.vpc_cidr_range
  instance_tenancy = "default"

  enable_dns_support   = true   
  enable_dns_hostnames = false  

  tags = {
    Name = "tool"
  }
}


################### Subnets ###################

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.tool.id
  cidr_block        = var.subnet1_range
  availability_zone = var.az1

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.tool.id
  cidr_block        = var.subnet2_range
  availability_zone = var.az2

  tags = {
    Name = "application_subnet"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.tool.id
  cidr_block        = var.subnet3_range
  availability_zone = var.az2

  tags = {
    Name = "kafka_subnet"
  }
}

resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.tool.id
  cidr_block        = var.subnet4_range
  availability_zone = var.az2

  tags = {
    Name = "database_subnet"
  }
}

################### Internet Gateway ###################

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.tool.id

  tags = {
    Name = "tool-igw"
  }
}

################### Elastic IP ###################

resource "aws_eip" "elastic_ip" {
  domain = "vpc"

  tags = {
    Name = "EIP"
  }
}

################### NAT Gateway ###################

resource "aws_nat_gateway" "NAT" {
  connectivity_type = var.connection_type
  subnet_id         = aws_subnet.public.id
  allocation_id     = aws_eip.elastic_ip.id

  tags = {
    Name = "NAT_gateway"
  }
}

################### Route Tables ###################

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.tool.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public_RT"
  }
}

resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.tool.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT.id
  }

  tags = {
    Name = "Private_RT"
  }
}

################### Route Table Associations ###################

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private_RT.id
}

################### Security Groups ###################

resource "aws_security_group" "publicSG" {
  vpc_id = aws_vpc.tool.id

  ingress {
    from_port   = var.all
    to_port     = var.all
    protocol    = var.anywhere
    cidr_blocks = [var.sg_cidr_range]
  }

  egress {
    from_port   = var.all
    to_port     = var.all
    protocol    = var.anywhere
    cidr_blocks = [var.sg_cidr_range]
  }

  tags = {
    Name = "publicSG"
  }
}

resource "aws_security_group" "privateSG" {
  vpc_id = aws_vpc.tool.id

  ingress {
    from_port   = var.all
    to_port     = var.all
    protocol    = var.anywhere
    cidr_blocks = [var.sg_cidr_range]
  }

  egress {
    from_port   = var.all
    to_port     = var.all
    protocol    = var.anywhere
    cidr_blocks = [var.sg_cidr_range]
  }

  tags = {
    Name = "privateSG"
  }
}
