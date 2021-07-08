terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region // Região de criação do terraform - referenciada no arquivo "variables.tf"
}

resource "random_id" "bucket" { // A aws não permite mais de um bucket com o mesmo nome e para facilitar a criação de bucket com nome unico, estamos usando essa função para gerar strings aleatorias para os buckets
  byte_length = 8               // string com 8 caracteres
}

resource "random_id" "bucket_2" { // random string para o bucket 2
  byte_length = 4                 // string com 4 caracteres
}

module "bucket" {                              // criação de bucket
  source = "./s3"                              // instanciando o main.tf no diretorio "./s3" onde tem o codigo fonte do bucket. (O source poderia apontar para um tf de um repositorio da internet)
  name   = "my-bucket-${random_id.bucket.hex}" // O nome concatenado do bucket sera "my-bucket"+string gerada na função "random_id"

  versioning = true // habilitando o versionamento, no diretorio ""./s3/variables.tf" o versionamento esta desligado com "default = false"

  tags = {
    "Name" = "Bucket com conteudo" // Criando tag para o bucket, no diretorio "./s3/variables.tf" as tags estão vazias -> tag { type = "map" "default = "" }
  }

  create_object = true                                // habilitando a criação de objetos nesse bucket, no diretorio "./s3/variables.tf" a criação esta desabilitada -> create_object { default = false}  
  object_key    = "files/${random_id.bucket.dec}.txt" // Nome do objeto criado no bucket
  object_source = "file.txt"                          // caminho do arquivo a ser criado
}

module "bucket-2" {                              // criação de bucket
  source = "./s3"                                // instanciando o main.tf no diretorio "./s3" onde tem o codigo fonte do bucket. (O source poderia apontar para um tf de um repositorio da internet)
  name   = "my-bucket-${random_id.bucket_2.hex}" // O nome concatenado do bucket sera "my-bucket"+string gerada na função "random_id"
}