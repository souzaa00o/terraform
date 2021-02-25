## Data Sources tem como função utilizar em seu projeto, dados de projetos externos

#terraform init -backend=true -backend-config="region=us-east-1" -backend-config="bucket=NOME DO BUCKET" -backend-config="key=ec2/ec2.tfstate"

provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3"{
    bucket = "my-bucket-test-for-data-source" // Nome do bucket de destino 
    key    = "ec2/ec2.tfstate"             // Diretorio de destino
    region = "us-east-1"           
  }
}

data "aws_ami" "ubuntu"{  // Declarando data source
    owners = [ "amazon" ] // Usando as AMIs da amazon
    most_recent = true    // Setando a versão mais recente
    name_regex = "ubuntu"
}

resource "aws_instance" "web" {   // criando instancia ec2
  ami = "${data.aws_ami.ubuntu.id}"    // usando os dados do data source acima
  instance_type = "${var.instance_type}"  // setando o tipo de maquina setado em "variables.tf"
}


