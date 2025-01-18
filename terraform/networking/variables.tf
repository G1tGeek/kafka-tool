########vpc###########

variable "vpc_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}

#######subnet##############

variable "subnet1_range" {
  type    = string
  default = "10.0.1.0/24"
}

variable "subnet2_range" {
  type    = string
  default = "10.0.2.0/24"
}

variable "subnet3_range" {
  type    = string
  default = "10.0.3.0/24"
}

variable "subnet4_range" {
  type    = string
  default = "10.0.4.0/24"
}

variable "subnet5_range" {
  type    = string
  default = "10.0.4.0/24"
}

variable "subnet6_range" {
  type    = string
  default = "10.0.4.0/24"
}

################availablity zone#####

variable "az1" {
  type    = string
  default = "us-east-1a"
}


variable "az2" {
  type    = string
  default = "us-east-1b"
}

variable "az3" {
  type    = string
  default = "us-east-1c"
}

variable "az4" {
  type    = string
  default = "us-east-1d"
}

###############NAT Gateway##########

variable "connection_type" {
  type    = string
  default = "public"
}

##############Route Table#######

variable "rt_cidr_range" {
  type    = string
  default = "0.0.0.0/0"
}

###########Security Groups#########

variable "sg_cidr_range" {
  type    = string
  default = "0.0.0.0/0"
}
