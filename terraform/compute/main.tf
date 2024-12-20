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

resource "aws_instance" "private1" {
  ami                    = var.ami_id
  instance_type          = var.ec2_medium
  key_name               = var.pem_key
  subnet_id              = var.private1_subnet_id
  vpc_security_group_ids = [var.privateSG_id]

  tags = {
    Name = "application-host"
  }
}

resource "aws_instance" "private2" {
  ami                    = var.ami_id
  instance_type          = var.ec2_medium
  key_name               = var.pem_key
  subnet_id              = var.private2_subnet_id
  vpc_security_group_ids = [var.privateSG_id]
  tags = {
    Name = "kafka-host"
  }
}

resource "aws_instance" "private3" {
  ami                    = var.ami_id
  instance_type          = var.ec2_medium
  key_name               = var.pem_key
  subnet_id              = var.private3_subnet_id
  vpc_security_group_ids = [var.privateSG_id]

  tags = {
    Name = "database-host"
  }
}