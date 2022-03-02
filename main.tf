/* Copyright (C) DevPanel Inc. - All Rights Reserved 
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Salim Lakhani <SL@DevPanel.com>, 2018 - 2021
 */

#############################
### Keys
#############################
output "priv_key" {
  value     = tls_private_key.main_key_pair.private_key_pem
  sensitive = true
}

output "pub_key" {
  value = tls_private_key.main_key_pair.public_key_pem
}

resource "tls_private_key" "main_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_lightsail_key_pair" "ssh_key" {
  name       = "${var.infras_name}-ssh-key"
  public_key = tls_private_key.main_key_pair.public_key_openssh
}

#############################
### LightSail Instance
#############################

resource "aws_lightsail_instance" "this" {
  name              = var.infras_name
  availability_zone = var.availability_zone
  blueprint_id      = var.blueprint_id
  bundle_id         = var.bundle_id
  key_pair_name     = aws_lightsail_key_pair.ssh_key.id
}

resource "aws_lightsail_static_ip_attachment" "this" {
  static_ip_name = aws_lightsail_static_ip.this.id
  instance_name  = aws_lightsail_instance.this.id
}

resource "aws_lightsail_static_ip" "this" {
  name  = "${var.infras_name}-static-ip"
}

resource "aws_lightsail_instance_public_ports" "allow_ports" {
  instance_name = aws_lightsail_instance.this.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs = [
      "0.0.0.0/0",
    ]
  }

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidrs = [
      "0.0.0.0/0",
    ]
  }

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidrs = [
      "0.0.0.0/0",
    ]
  }

  port_info {
    protocol = "tcp"
    from_port = "3306"
    to_port = "3306"
    cidrs = [
      "0.0.0.0/0",
    ]
  }
}

#############################
### Post Commands
#############################

resource "local_file" "priv_key" {
  filename = "${path.module}/keys/id_rsa"
  file_permission = "0400"
  sensitive_content  = tls_private_key.main_key_pair.private_key_pem
  depends_on = [
    tls_private_key.main_key_pair,
    aws_lightsail_instance.this,
    aws_lightsail_static_ip_attachment.this
  ]

  provisioner "remote-exec" {
    connection {
        host        = aws_lightsail_static_ip.this.ip_address
        type        = "ssh"
        user        = "ubuntu"
        private_key = tls_private_key.main_key_pair.private_key_pem
      }
      script = "userdata.sh"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${aws_lightsail_static_ip.this.ip_address},' --key-file ${path.module}/keys/id_rsa  -e 'infras_name=${var.infras_name} database_password=${var.database_password}' ansible/playbooks/deploy-lamp.yml"
  }
}
