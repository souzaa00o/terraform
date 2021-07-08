## KICK-OFF

## Criando s3 bucket via tf

terraform {   // Obrigatorio 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# variables.tf -> Arquivo criado para armazenar variaveis -> O meu arquivo "variables.tf" guarda minha access e secret key, por isso ele não estara disponivel no github

# Configure the AWS Provider
provider "aws" {  
  region = "${var.region}"  // Região de criação do terraform - referenciada no arquivo "variables.tf"
  access_key = "${var.access_key}"     // AWS IAM Access_key - referenciada no arquivo "variables.tf"
  secret_key = "${var.secret_key}"   //  AWS IAM secret_key - referenciada no arquivo "variables.tf"
}

# Create a VPC  
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_s3_bucket" "b" {      // Criação S3 Bucket com o nome de objeto "b"
  bucket = "my-tf-test-bucket-labs-tst-s3"    // Nome Bucket
  acl    = "private"

  tags = {
    Name        = "My super bucket"
    Environment = "Prd"
  }
}