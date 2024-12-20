################### VPC Peering Connection ###################

resource "aws_vpc_peering_connection" "tool_to_default" {
  vpc_id        = var.tool_vpc_id
  peer_vpc_id   = var.default_vpc_id
  auto_accept   = true

  tags = {
    Name = "tool-to-default-peering"
  }
}

################### Routes for Tool VPC ###################

resource "aws_route" "tool_to_default_public" {
  route_table_id            = var.public_route_table_id
  destination_cidr_block    = var.default_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.tool_to_default.id
}

resource "aws_route" "tool_to_default_private" {
  route_table_id            = var.private_route_table_id
  destination_cidr_block    = var.default_vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.tool_to_default.id
}

################### Default VPC Route Table Update ###################

data "aws_route_table" "default" {
  vpc_id = var.default_vpc_id
}

resource "aws_route" "default_to_tool" {
  route_table_id            = data.aws_route_table.default.id
  destination_cidr_block    = var.tool_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.tool_to_default.id
}
