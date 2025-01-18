output "bastion_public_ip" {
  value = aws_instance.public.public_ip
}

output "kafka1_private_ip" {
  value = aws_instance.kafka1.private_ip
}

output "kafka2_private_ip" {
  value = aws_instance.kafka2.private_ip
}

output "kafka3_private_ip" {
  value = aws_instance.kafka3.private_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "database_private_ip" {
  value = aws_instance.database.private_ip
}