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

output "app_subnet_id" {
  value = aws_subnet.app_subnet.id
}

output "kafka_subnet1_id" {
  value = aws_subnet.kafka_subnet1.id
}

output "kafka_subnet2_id" {
  value = aws_subnet.kafka_subnet2.id
}

output "kafka_subnet3_id" {
  value = aws_subnet.kafka_subnet3.id
}

output "database_subnet_id" {
  value = aws_subnet.database_subnet.id
}

output "appSG_id" {
  value = aws_security_group.appSG.id
}

output "kafkaSG_id" {
  value = aws_security_group.kafkaSG.id
}

output "databaseSG_id" {
  value = aws_security_group.databaseSG.id
}