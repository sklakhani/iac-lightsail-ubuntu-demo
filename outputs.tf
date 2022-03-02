/* Copyright (C) DevPanel Inc. - All Rights Reserved 
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Salim Lakhani <SL@DevPanel.com>, 2018 - 2021
 */

output "instance_arn" {
  value = aws_lightsail_instance.this.arn
  description = "The ARN of the Lightsail instance"
}

output "cpu_count" {
  value = aws_lightsail_instance.this.cpu_count
  description = "The number of vCPUs the instance has."
}

output "ram_size" {
  value = aws_lightsail_instance.this.ram_size
  description = "The amount of RAM in GB on the instance"
}

output "is_static_ip" {
  value = aws_lightsail_instance.this.is_static_ip
  description = "A Boolean value indicating whether this instance has a static IP assigned to it."
}

output "private_ip_address" {
  value = aws_lightsail_instance.this.private_ip_address
  description = "The private IP address of the instance."
}

output "public_ip_address" {
  value = aws_lightsail_static_ip.this.ip_address
  description = "The public IP address of the instance"
}

output "database_host" {
  value = aws_lightsail_static_ip.this.ip_address
  description = "The address of database server that applications can use to connect to"
}

output "database_port" {
  value = 3306
  description = "The port of database that applications can use to connect to"
}

output "database_username" {
  value = "root"
  description = "The username of database that applications can use to connect to"
}

output "database_password" {
  value = var.database_password
  description = "The password of database that applications can use to connect to"
  sensitive = true
}