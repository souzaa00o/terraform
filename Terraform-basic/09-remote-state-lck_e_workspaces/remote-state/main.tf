provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


locals {
  account_id        = "${data.aws_caller_identity.current.account_id}"
  state_bucket_name = "${var.project_name}-${local.account_id}-${var.region}-remote-state"
  state_table_name  = "${local.state_bucket_name}"
}

resource "aws_dynamodb_table" "locking" {   // Criando tabela no dynamodb
  name           = "${local.state_table_name}"  // Nome da tabela
  read_capacity  = "20" // Capacidade de leitura
  write_capacity = "20" // Capacidade de escrita
  hash_key       = "LockID" 

  attribute { 
    name = "LockID"
    type = "S" // tipo string
  }
}


resource "aws_s3_bucket" "state" { // Bucket
  bucket = "${local.state_bucket_name}" // Nome
  region = "${data.aws_region.current.name}"

  versioning { // Versionamento do bucket habilitado
    enabled = true
  }
/*
  server_side_encryption_configuration{ // Encriptação
    "rule"{
       "apply_server_side_encryption_by_default" {
           sse_algorithm = "AES256"
       }
    }
  }
*/
    tags = { // tags
        Name = "terraform-remote-state-bucket"
        Environment = "global"
        project = "${var.project_name}"
    }
}