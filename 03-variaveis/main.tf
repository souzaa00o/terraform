# Variables

# As configurações de AWS Provider foram feitas no terminal.
# O comando "aws configure" solicita a região de criação e Access e secret Key no terminal.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

resource "aws_instance" "web" {
    ami = "${var.ami}"
    instance_type = "${var.type}"

    // ipv6_addresses = "${var.ips}"

    tags = "${var.tags}"
}