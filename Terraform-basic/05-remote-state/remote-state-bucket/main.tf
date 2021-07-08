provider "aws" {
  region = "${var.region}"
}

module "bucket" {                // Criação de bucket
  source = "../../04-modulos/s3" // instanciando o bucket criado no projeto anterior

  name       = "${var.bucket_name}-${var.env}" // concatenando o nome do bucket com a variavel de ambiente (ServidorXTPO-DEV)
  versioning = true                            // habilitando o versionamento do bucket criado em "../../04-modulos/s3"

  tags = {
    "Env"  = "${var.env}" // tageando instancia com a variavel de ambiente
    "Name" = "Terraform Remote State"
  }
}