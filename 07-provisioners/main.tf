## PROVISIONERS

## Usados para executar scripts, tanto na maquina local ou remota, na criação ou destruição dos recursos
## Os provisioners usado nesse projeto são: File, Local-exec e Remote-exec.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "web" {     // Criando instancia ec2
    ami = "${var.ami}"   
    instance_type = "${var.instance_type}"
    key_name = "tf_test"    // Setando a chave remota criada na aws
    
    tags = {
      "Name" = "TESTE TF"
    }

    provisioner "file" {    // O provisioner "file" é usado para copiar arquivos da nossa maquina, para uma maquina remota
        source = "test-log.log" // O provisioner "file" é usado para copiar arquivos da nossa maquina, para uma maquina remota
        destination = "tmp/file.log" // Destino do arquivo na maquina remota

        connection {   // Configurando a conexão
            type = "ssh"    // tipo de conexão "ssh"
            user = "ec2-user" // Com o usuario "ec2-user"
            //timeout = "5m"  // Timeout de 1 minuto
            private_key = "${file("~/Downloads/tf_test.pem")}"  // Caminho da chave local
            host = "aws"
            //TEMOS QUE COLOCAR O ARGUMENTO HOST, ARGUMENTO OBRIGATORIO
        }
    }

    provisioner "remote-exec" { // O provisioner "remote-exec" é utilizado para executar linhas de comandos ou scripts na maquina remota
      inline  = [   // Os comandos abaixo instalam o apache na instancia 
          "sleep 10",
          "sudo yum update -y",
          "sudo yum install -y httpd",
          "sudo service httpd start",
          "sudo chkconfig httpd on",
          "sleep 10",
      ]
      
      connection {   // A conexão tem as mesmas configurações do provisioner anterior, por ser na mesma maquina
            type = "ssh"
            user = "ec2-user" 
            //timeout = "5m"  
            private_key = "${file("~/Downloads/tf_test.pem")}"  
            host = "aws"
            //TEMOS QUE COLOCAR O ARGUMENTO HOST, ARGUMENTO OBRIGATORIO
        }
    }
}



resource "null_resource" "null" { // O "null_resource" é a criação de recursos nulos, utilizados para executar funções 
  provisioner "local-exec" {    // Dentro desse recurso vamos executar o "local-exec", utilizado para executar comandos na sua maquina local assim que o tf for aplicado
      command = "echo ${aws_instance.web.id}:${aws_instance.web.public_ip} >> public_ips.txt"  // Esse comando pega o ID e IP publico da instancia e joga os resultados para "public_ips.txt" na maquina local
 
      ## Por ser uma execução para a maquina local, esse provisioner não precisa do parametro "connections"
  }
}