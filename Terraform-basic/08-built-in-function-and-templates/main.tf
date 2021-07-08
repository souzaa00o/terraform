terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = lookup(var.region, var.env) // o lookup seta o valor da variavel "region" de acordo com a "env" solicitado na console
}

resource "random_id" "nomes" {
  byte_length = 8
}

locals {
  common_tags = {
    "Project" = "Voando com Terraform"
    "Owner"   = "Henrique Souza"
    "Year"    = "2021"
  }

  file_ext    = "zip"
  object_name = "my-data"
}

data "template_file" "json" {      // Os templates são utilizados para processar strings mais complexas
  template = file("file.json.tpl") // Indicando o path do documento a ser processado

  vars = { // As variaveis abaixo serão passadas dinamicamente para o arquivo Json referenciado acima
    "age"    = 53
    "name"   = "Severino"
    "gender" = "Male"
    "eye"    = "Brown"
  }
}

data "archive_file" "json" {                                                 // Archive_file: gera arquivos de acordo com os parametros passados abaixo
  type        = "zip"                                                        // O arquivo a ser criado sera do tipo "zip"
  output_path = "${path.module}/file/${local.object_name}.${local.file_ext}" //  Local de criação do arquivo

  source {
    content  = data.template_file.json.rendered // Em content nos passamos o conteudo do arquivo que vem de "data.template_file.json" e o "rendered" no final, indica que o arquivo sera renderizado, assim criando o novo arquivo ja com as variaveis do "data.template_file.json"
    filename = "${local.object_name}.json"      // Nome do doc gerado no locals
  }
}


module "bucket" {
  source = "../04-modulos/s3"

  name = "my-bucket-${random_id.nomes.dec}"
  tags = merge(local.common_tags, map("name", "Meu bucket"), map("env", format("%s", var.env))) // Merge: faz o junção de varios maps, em um unico map 

  create_object = true
  object_key    = "${random_id.nomes.dec}.${local.file_ext}"
  object_source = data.archive_file.json.output_path


}
