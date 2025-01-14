output "bastion_public_ip" {
  value       = module.compute.bastion_public_ip
  description = "The public IP address of the bastion host."
}

output "application_private_ip" {
  value       = module.compute.application_private_ip
  description = "The private IP address of the application host."
}

output "kafka_private_ip" {
  value       = module.compute.kafka_private_ip
  description = "The private IP address of the Kafka host."
}

output "database_private_ip" {
  value       = module.compute.database_private_ip
  description = "The private IP address of the database host."
}
