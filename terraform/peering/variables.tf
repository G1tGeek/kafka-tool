variable "tool_vpc_id" {
  description = "VPC ID of the Tool VPC"
  type        = string
}

variable "tool_cidr_block" {
  description = "CIDR block of the Tool VPC"
  type        = string
}

variable "default_vpc_id" {
  description = "VPC ID of the Default VPC"
  type        = string
}

variable "default_vpc_cidr_block" {
  description = "CIDR block of the Default VPC"
  type        = string
}

variable "public_route_table_id" {
  description = "Public Route Table id"
  type        = string
}

variable "private_route_table_id" {
  description = "Private Route Table id"
  type        = string
}