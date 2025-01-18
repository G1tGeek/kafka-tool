############EC 2 Instance#########

variable "ami_id" {
  type    = string
  default = "ami-005fc0f236362e99f"
}

variable "ec2_micro" {
  type    = string
  default = "t3.micro"
}

variable "ec2_medium" {
  type    = string
  default = "t3.medium"
}

variable "pem_key" {
  type    = string
  default = "tool"
}

variable "public_subnet_id" {
  type        = string
}

variable "publicSG_id" {
  type        = string
}

variable "app_subnet_id" {
  type        = string
}

variable "database_subnet_id" {
  type        = string
}

variable "kafka_subnet1_id" {
  type        = string
}

variable "kafka_subnet2_id" {
  type        = string
}

variable "kafka_subnet3_id" {
  type        = string
}

variable "appSG_id" {
  type        = string
}

variable "kafkaSG_id" {
  type        = string
}

variable "databaseSG_id" {
  type        = string
}