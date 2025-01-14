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
  private1_subnet_id = module.networking.private1_subnet_id
  private2_subnet_id = module.networking.private2_subnet_id
  private3_subnet_id = module.networking.private3_subnet_id
  privateSG_id = module.networking.privateSG_id
}

terraform {
  backend "s3" {
    bucket  = "yuvraj-tf-bucket"
    key     = "terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
  }
}

# Write outputs to a .txt file
resource "local_file" "outputs" {
  content = <<EOT
basiton-host ${module.compute.bastion_public_ip}
application-host ${module.compute.application_private_ip}
kafka-host ${module.compute.kafka_private_ip}
database-host ${module.compute.database_private_ip}
EOT
  filename = "ansible/outputs.txt"
}
