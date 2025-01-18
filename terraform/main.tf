module "networking" {
  source = "./networking"
}


module "peering" {
  source = "./peering"

  tool_vpc_id             = module.networking.tool_vpc_id
  tool_cidr_block         = module.networking.tool_cidr_block
  default_vpc_id          = module.networking.default_vpc_id
  default_vpc_cidr_block  = module.networking.default_vpc_cidr_block
  public_route_table_id      = module.networking.public_route_table_id
  private_route_table_id      = module.networking.private_route_table_id
}

module "compute" {
  source = "./compute"
  public_subnet_id = module.networking.public_subnet_id
  publicSG_id = module.networking.publicSG_id
  app_subnet_id = module.networking.app_subnet_id
  kafka_subnet1_id = module.networking.kafka_subnet1_id
  kafka_subnet2_id = module.networking.kafka_subnet2_id
  kafka_subnet3_id = module.networking.kafka_subnet3_id
  database_subnet_id = module.networking.database_subnet_id
  appSG_id = module.networking.appSG_id
  kafkaSG_id = module.networking.kafkaSG_id
  databaseSG_id = module.networking.databaseSG_id
}

terraform {
  backend "s3" {
    bucket  = "yuvraj-tf-bucket"
    key     = "terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
  }
}

resource "local_file" "output1" {
  content = <<EOT
${module.compute.kafka1_private_ip}
EOT
  filename = "kafka1.txt"
}

resource "local_file" "output1" {
  content = <<EOT
${module.compute.kafka2_private_ip}
EOT
  filename = "kafka2.txt"
}

resource "local_file" "output1" {
  content = <<EOT
${module.compute.kafka3_private_ip}
EOT
  filename = "kafka3.txt"
}
