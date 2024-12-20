output "tool_vpc_id" {
  value = aws_vpc.tool.id
}

output "tool_cidr_block" {
  value = aws_vpc.tool.cidr_block
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_vpc_cidr_block" {
  value = data.aws_vpc.default.cidr_block
}

output "public_route_table_id" {
  value = aws_route_table.public_RT.id
}

output "private_route_table_id" {
  value = aws_route_table.private_RT.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "publicSG_id" {
  value = aws_security_group.publicSG.id
}

output "private1_subnet_id" {
  value = aws_subnet.private1.id
}

output "private2_subnet_id" {
  value = aws_subnet.private2.id
}

output "private3_subnet_id" {
  value = aws_subnet.private3.id
}

output "privateSG_id" {
  value = aws_security_group.privateSG.id
}