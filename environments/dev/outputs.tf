output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = module.ec2.instance_public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}