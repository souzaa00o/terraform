terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.region}"          // Região de criação do terraform - referenciada no arquivo "variables.tf"
  access_key = "${var.access_key}"   // AWS IAM Access_key - referenciada no arquivo "variables.tf"
  secret_key = "${var.secret_key}"   //  AWS IAM secret_key - referenciada no arquivo "variables.tf"
}

# Create a VPC  
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_s3_bucket" "b" {          // Criação de s3 bucket com o recurso de nome "b"
  bucket = "my-tf-test-bucket-labs-tst-s3"  // Nome do Bucket
  acl    = "private"

  tags = {          // Tags
    Name        = "My super bucket"
    Environment = "Prd"
  }
}

resource "aws_s3_bucket_object" "object" {      // Criação de objetos no bucket
  bucket = "${aws_s3_bucket.b.id}"      // Refencia/Interpolação ao Bucket criado acima de nome "b"
  key    = "hello-world.txt"    // Nome do arquivo criado no bucket
  source = "file.txt"   // Caminho do arquivo
  
}