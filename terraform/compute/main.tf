################### EC2 Instances ###################

resource "aws_instance" "public" {
  ami                    = var.ami_id
  instance_type          = var.ec2_micro
  key_name               = var.pem_key
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.publicSG_id]
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}

resource "aws_instance" "app" {
  ami                    = var.ami_id
  instance_type          = var.ec2_medium
  key_name               = var.pem_key
  subnet_id              = var.app_subnet_id
  vpc_security_group_ids = [var.appSG_id]

  tags = {
    Name = "application-host"
  }
}

resource "aws_instance" "kafka1" {
  ami                    = var.ami_id
  instance_type          = var.ec2_medium
  key_name               = var.pem_key
  subnet_id              = var.kafka_subnet1_id
  vpc_security_group_ids = [var.kafkaSG_id]

  tags = {
    Name = "kafka-host1"
  }
}

resource "aws_instance" "kafka2" {
  ami                    = var.ami_id
  instance_type          = var.ec2_medium
  key_name               = var.pem_key
  subnet_id              = var.kafka_subnet2_id
  vpc_security_group_ids = [var.kafkaSG_id]

  tags = {
    Name = "kafka-host2"
  }
}

resource "aws_instance" "kafka3" {
  ami                    = var.ami_id
  instance_type          = var.ec2_medium
  key_name               = var.pem_key
  subnet_id              = var.kafka_subnet3_id
  vpc_security_group_ids = [var.kafkaSG_id]

  tags = {
    Name = "kafka-host3"
  }
}

resource "aws_instance" "database" {
  ami                    = var.ami_id
  instance_type          = var.ec2_medium
  key_name               = var.pem_key
  subnet_id              = var.database_subnet_id
  vpc_security_group_ids = [var.databaseSG_id]

  tags = {
    Name = "database-host"
  }
}
