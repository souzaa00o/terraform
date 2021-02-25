p rovider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "web"{ // Setando remote state e acessando as informações do data source declarado em "../ec2/main.tf"
    backend "s3" {  
        config = {
            bucket = "bckt-teste-remote-state-dev"  // Bucket de destino
            key = "ec2/ec2.tfstate" // caminho de criação do arquivo no bucket
            region = "${var.region}" // região de deploy
        }
    }
}

## Os Locals são variaveis que nos permite executar funções ou condições para executar dentro do nosso diretorio

locals {    // os dados estão sendo convertidos do "data_source.remote_state" declarado acima
  instance_id = "${data.terraform_remote_state.web.id}"
  ami = "${data.terraform_remote_state.web.ami}"
  arn = "${data.terraform_remote_state.web.arn}"
}

module "bucket" {                // Criação de bucket
  source = "../../04-modulos/s3" // instanciando o bucket criado no projeto anterior

  name       = "${var.bucket_name}-${var.env}" // concatenando o nome do bucket com a variavel de ambiente (ServidorXTPO-DEV)
  versioning = true                            // habilitando o versionamento do bucket criado em "../../04-modulos/s3"

  tags = {
    "Env"  = "${var.env}" // tageando instancia com a variavel de ambiente
    "Name" = "Intancias teste"
  }

  create_object = true
  object_key = "instances/instances-${local.ami}.txt" // "local.ami" usando variavel declarada no local acima 
  object_source = "output.txt "

}