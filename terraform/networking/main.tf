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

resource "aws_subnet" "kafka_subnet1" {
  vpc_id            = aws_vpc.tool.id
  cidr_block        = var.subnet2_range
  availability_zone = var.az2

  tags = {
    Name = "kafka_subnet1"
  }
}

resource "aws_subnet" "kafka_subnet2" {
  vpc_id            = aws_vpc.tool.id
  cidr_block        = var.subnet3_range
  availability_zone = var.az3

  tags = {
    Name = "kafka_subnet2"
  }
}

resource "aws_subnet" "kafka_subnet3" {
  vpc_id            = aws_vpc.tool.id
  cidr_block        = var.subnet4_range
  availability_zone = var.az4

  tags = {
    Name = "kafka_subnet3"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.tool.id
  cidr_block        = var.subnet5_range
  availability_zone = var.az2

  tags = {
    Name = "application_subnet"
  }
}


resource "aws_subnet" "database_subnet" {
  vpc_id            = aws_vpc.tool.id
  cidr_block        = var.subnet6_range
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
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.kafka_subnet1.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.kafka_subnet2.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private4" {
  subnet_id      = aws_subnet.kafka_subnet3.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private5" {
  subnet_id      = aws_subnet.database_subnet.id
  route_table_id = aws_route_table.private_RT.id
}

################### Security Groups ###################

resource "aws_security_group" "publicSG" {
  vpc_id = aws_vpc.tool.id

  ingress {
    from_port   = var.zero
    to_port     = var.zero
    protocol    = var.anywhere
    cidr_blocks = [var.sg_cidr_range]
  }

  egress {
    from_port   = var.zero
    to_port     = var.zero
    protocol    = var.anywhere
    cidr_blocks = [var.sg_cidr_range]
  }

  tags = {
    Name = "publicSG"
  }
}

resource "aws_security_group" "appSG" {
  vpc_id = aws_vpc.tool.id

  ingress {
    from_port   = var.ssh
    to_port     = var.ssh
    protocol    = var.tcp
    cidr_blocks = [var.sg_cidr_range]
  }

  ingress {
    from_port   = var.https
    to_port     = var.https
    protocol    = var.tcp
    cidr_blocks = [var.sg_cidr_range]
  }

  egress {
    from_port   = var.zero
    to_port     = var.zero
    protocol    = var.anywhere 
    cidr_blocks = [var.sg_cidr_range]
  }

  tags = {
    Name = "appSG"
  }
}

resource "aws_security_group" "kafkaSG" {
  vpc_id = aws_vpc.tool.id


  ingress {
    from_port   = var.ssh
    to_port     = var.ssh
    protocol    = var.tcp
    cidr_blocks = [var.sg_cidr_range]
  }

  ingress {
    from_port   = var.kafka
    to_port     = var.kafka
    protocol    = var.tcp
    cidr_blocks = [var.sg_cidr_range]
  }

  egress {
    from_port   = var.zero
    to_port     = var.zero
    protocol    = var.anywhere
    cidr_blocks = [var.sg_cidr_range]
  }

  tags = {
    Name = "kafkaSG"
  }
}

resource "aws_security_group" "databaseSG" {
  vpc_id = aws_vpc.tool.id

  ingress {
    from_port   = var.ssh
    to_port     = var.ssh
    protocol    = var.tcp
    cidr_blocks = [var.sg_cidr_range]
  }

  ingress {
    from_port   = var.mongoDB
    to_port     = var.mongoDB
    protocol    = var.tcp
    cidr_blocks = [var.sg_cidr_range]
  }

  ingress {
    from_port   = var.kafka
    to_port     = var.kafka
    protocol    = var.tcp
    cidr_blocks = [var.sg_cidr_range]
  }

  egress {
    from_port   = var.zero
    to_port     = var.zero
    protocol    = var.anywhere
    cidr_blocks = [var.sg_cidr_range]
  }

  tags = {
    Name = "databaseSG"
  }
}
