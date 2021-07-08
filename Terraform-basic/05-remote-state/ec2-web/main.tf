#### REMOTE STATE  ####

##  Para setar nosso remote state é necessario passar os 3 parametros abaixo, bucket, key e region
##  Os parametro podem ser escritos como harded-code como no exemplo abaixo ou passados em CLI no terraform init
##  parametrizando com init: terraform init -backend=true -backend-config="NOME DO BUCKET DESTINO" -backend-config="region=us-east-1"

terraform {                                // criando remote state
  backend "s3" {                           // setando remote state no s3
    bucket = "bckt-teste-remote-state-dev" // Nome do bucket de destino 
    key    = "ec2/ec2.tfstate"             // Diretorio de destino
    region = "us-east-1"                   // Região de deploy
  }
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "web" { // criando instancia ec2
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
}